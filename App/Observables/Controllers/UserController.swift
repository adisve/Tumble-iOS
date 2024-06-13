//
//  UserModel.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-02-13.
//

import Foundation
import SwiftUI
import Combine

/// Controller handling any changes to the specific user
/// currently authorized in the application. Also attempts
/// to authorize the session on startup.
final class UserController: ObservableObject {
    @Inject var authManager: AuthManager
    @Inject var kronoxManager: KronoxManager
    @Inject var preferenceService: PreferenceService
    
    let popupFactory: PopupFactory = .shared
    
    @Published var authStatus: AuthStatus = .unAuthorized
    @Published var user: TumbleUser? = nil
    @Published var refreshToken: Token? = nil
    @Published var sessionDetails: Token? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task.detached(priority: .userInitiated) { [weak self] in
            await self?.autoLogin()
        }
    }
    
    /// Attempts to log out user, and also remove any keychain items
    /// saved that are related to authorization - tokens, passwords, etc.
    func logOut(username: String? = nil) async throws {
        do {
            let userToLogOut: String
            if let username = username {
                userToLogOut = username
            } else if let user = user?.username {
                userToLogOut = user
            } else {
                return
            }

            try await authManager.logOutUser(username: userToLogOut)
            preferenceService.removeUserAccount(username: userToLogOut)
            AppLogger.shared.debug("Successfully deleted items from KeyChain")

            setUnauthorized()
        } catch {
            AppLogger.shared.error("Failed to log out user: \(error.localizedDescription)")
            throw error
        }
    }

    
    /// Attempts to log in the user through their institutional credentials
    /// and saves any information it can in keychain storage, such as the
    /// refresh token, user name, password.
    func logIn(
        authSchoolId: Int,
        username: String,
        password: String,
        school: School
    ) async throws {
        do {
            
            /// Use tumble backend to log in and fetch user information
            AppLogger.shared.info("Attempting to log in user \(username)")
            let userRequest = NetworkRequest.KronoxUserLogin(username: username, password: password)
            let user: TumbleUser = try await authManager.loginUser(user: userRequest, school: school)
            
            /// If the user is already saved we do nothing
            if alreadySaved(user: user) {
                PopupToast(popup: popupFactory.accountAlreadyExists()).showAndStack()
                return
            }
            
            /// Account has not been registered before so
            /// we set it as the default account
            preferenceService.updateMostRecentUser(to: user.username)
            preferenceService.setUserAccount(username: user.username, authSchoolId: user.school.id)
            
            /// Save user in device keychain as decoded object
            try await self.authManager.setUser(user)
            
            /// Get the refresh and session tokens
            let refreshToken: Token? = await authManager.getToken(.refreshToken, username: username)
            let sessionDetails: Token? = await authManager.getToken(.sessionDetails, username: username)
            
            /// Update app state to reflect recently signed in user
            AppLogger.shared.debug("Successfully logged in user \(user.username)")
            setAuthorized(user: user, refreshToken: refreshToken, sessionDetails: sessionDetails)
        } catch {
            setUnauthorized()
            throw Error.generic(reason: "Failed to log in user")
        }
    }
    
    /// Attempts to automatically log in the user by finding any available
    /// information in the keychain storage of the phone.
    func autoLogin() async {
        
        /// Get most recent username and auth school id.
        /// If these do not exist we don't even attempt to sign in
        guard let mostRecentUser = preferenceService.getLastUser(),
              let authSchoolId = preferenceService.getAuthSchoolForUsername(mostRecentUser) else { return }
        
        AppLogger.shared.info("User: \(mostRecentUser)")
        AppLogger.shared.info("Auth school id: \(authSchoolId)")
                
        /// Get the refresh and session tokens for this user
        AppLogger.shared.info("Attempting auto login for \(mostRecentUser)", source: "UserController")
        let refreshToken: Token? = await authManager.getToken(.refreshToken, username: mostRecentUser)
        let sessionDetails: Token? = await authManager.getToken(.sessionDetails, username: mostRecentUser)
        
        do {
            /// Auto login and eventually update user information 
            /// locally based on newly received data
            let user: TumbleUser = try await authManager.autoLoginUser(authSchoolId: authSchoolId, username: mostRecentUser)
            try await self.authManager.setUser(user)
            
            setAuthorized(
                user: user, refreshToken: refreshToken, sessionDetails: sessionDetails
            )
            
        } catch AuthManager.AuthError.autoLoginError(let user) {
            setAuthorized(user: user)
        } catch {
            AppLogger.shared.error("Failed to log in user: \(error)")
            setUnauthorized()
        }
    }
    
    func alreadySaved(user: TumbleUser) -> Bool {
        return preferenceService.getAllUserAccounts().contains { $0.key == user.username }
    }
    
    func setAuthorized(user: TumbleUser, refreshToken: Token? = nil, sessionDetails: Token? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.user = user
            self?.refreshToken = refreshToken
            self?.sessionDetails = sessionDetails
            self?.authStatus = .authorized
        }
    }
    
    func setUnauthorized() {
        DispatchQueue.main.async {
            self.authStatus = .unAuthorized
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
