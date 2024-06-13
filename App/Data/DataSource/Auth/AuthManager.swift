//
//  AuthManager.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-02-13.
//

import Foundation

class AuthManager {
    private let urlRequestUtils = NetworkUtilities.shared
    private let keychainManager = KeyChainManager()
    private let urlSession: URLSession = URLSession.shared
    
    enum AuthError: Swift.Error {
        case autoLoginError(user: TumbleUser)
        case httpResponseError
        case tokenError
        case decodingError
        case requestError
    }

    func loginUser(user: NetworkRequest.KronoxUserLogin, school: School) async throws -> TumbleUser {
        let urlRequest = try createLoginRequest(authSchoolId: school.id, user: user)
        return try await performLoginRequest(urlRequest, with: user, school: school)
    }
    
    func logOutUser(username: String) async throws {
        AppLogger.shared.info("Logging out user")
        try await clearKeychainData(for: [
            "\(username)-\(TokenType.refreshToken.rawValue)",
            "\(username)-\(TokenType.sessionDetails.rawValue)", "\(username)-tumble-user"]
        )
    }

    func autoLoginUser(authSchoolId: Int, username: String) async throws -> TumbleUser {
        guard let user = await getUser(username: username) else {
            throw AuthError.decodingError
        }
        let refreshToken = await getToken(.refreshToken, username: username)
        let sessionDetails = await getToken(.sessionDetails, username: username)
        
        let urlRequest = try createAutoLoginRequest(authSchoolId: authSchoolId, refreshToken: refreshToken, sessionDetails: sessionDetails)
        
        return try await performAutoLoginRequest(urlRequest, with: user)
    }

    // MARK: - Private Methods

    private func createLoginRequest(authSchoolId: Int, user: NetworkRequest.KronoxUserLogin) throws -> URLRequest {
        return try urlRequestUtils.createUrlRequest(
            method: .post,
            endpoint: .login(schoolId: String(authSchoolId)),
            body: user
        )
    }

    private func performLoginRequest(
        _ urlRequest: URLRequest,
        with user: NetworkRequest.KronoxUserLogin,
        school: School
    ) async throws -> TumbleUser {
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AuthError.httpResponseError
        }
        
        try await storeUpdatedTokensIfNeeded(from: httpResponse, username: user.username)
        let kronoxUser = try decodeKronoxUser(from: data)

        return TumbleUser(username: kronoxUser.username, name: kronoxUser.name, school: school)
    }

    private func performAutoLoginRequest(_ urlRequest: URLRequest, with user: TumbleUser) async throws -> TumbleUser {
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode > 299 {
                AppLogger.shared.info("Username: \(user.username), name \(user.name)")
                AppLogger.shared.info("Status code \(statusCode) received")
                try await logOutUser(username: user.username)
                throw AuthError.httpResponseError
            }

            try await storeUpdatedTokensIfNeeded(from: response as? HTTPURLResponse, username: user.username)
            let kronoxUser = try decodeKronoxUser(from: data)

            return TumbleUser(username: user.username, name: kronoxUser.name, school: user.school)
        } catch {
            if Network.shared.connected {
                try await logOutUser(username: user.username)
                throw AuthError.requestError
            }
            throw AuthError.autoLoginError(user: user)
        }
    }

    private func storeUpdatedTokensIfNeeded(from httpResponse: HTTPURLResponse?, username: String) async throws {
        if let refreshToken = httpResponse?.allHeaderFields["x-auth-token"] as? String,
           let sessionDetails = httpResponse?.allHeaderFields["x-session-token"] as? String {
            try await setToken(Token(value: refreshToken, createdDate: Date.now), for: .refreshToken, username: username)
            try await setToken(Token(value: sessionDetails, createdDate: Date.now), for: .sessionDetails, username: username)
        }
    }

    private func decodeKronoxUser(from data: Data) throws -> Response.KronoxUser {
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(Response.KronoxUser.self, from: data) else {
            AppLogger.shared.debug("Could not decode user. Data is: \(data)")
            throw AuthError.decodingError
        }
        return result
    }

    private func createAutoLoginRequest(authSchoolId: Int, refreshToken: Token? = nil, sessionDetails: Token? = nil) throws -> URLRequest {
        return try urlRequestUtils.createUrlRequest(
            method: .get,
            endpoint: .users(schoolId: String(authSchoolId)),
            refreshToken: refreshToken?.value,
            sessionDetails: sessionDetails?.value,
            body: nil as String?
        )
    }

    private func clearKeychainData(for keys: [String]) async throws {
        for key in keys {
            try await keychainManager.deleteKeyChain(for: key, account: "Tumble for Kronox")
        }
    }

    // MARK: - Keychain Management
    
    /// Fetch most recent user object based on the username
    /// that is passed
    func getUser(username: String) async -> TumbleUser? {
        AppLogger.shared.info("Attempting to get user object for \(username)")
        let service = "\(username)-tumble-user"
        let account = "\(username)-account"
        
        guard let data = try? await keychainManager.readKeyChain(for: service, account: account),
              let user = try? JSONDecoder().decode(TumbleUser.self, from: data) else {
            AppLogger.shared.info("Could not decode Tumble user")
            return nil
        }
        return user
    }
    
    /// Fetch most recent token based on its type and the specific username
    /// related to that token
    func getToken(_ tokenType: TokenType, username: String) async -> Token? {
        AppLogger.shared.info("Attempting to get user token for \(username)")
        let service = "\(username)-\(tokenType.rawValue)"
        let account = "\(username)-account"
        
        guard let data = try? await keychainManager.readKeyChain(for: service, account: account),
              let token = try? JSONDecoder().decode(Token.self, from: data) else {
            AppLogger.shared.info("Could not decode token")
            return nil
        }
        return token
    }

    /// Save decoded user object to keychain based on the given username to
    /// allow for multiple user accounts to be saved on the same device
    func setUser(_ newUser: TumbleUser?) async throws {
        guard let newUser = newUser, let data = try? JSONEncoder().encode(newUser) else { return }
        let service = "\(newUser.username)-tumble-user"
        let account = "\(newUser.username)-account"
        AppLogger.shared.info("Saving user in \(service)")
        try await keychainManager.saveKeyChain(data, for: service, account: account)
    }

    /// Save decoded user token to keychain based on the given username to
    /// allow for multiple user account tokens to be saved on the same device
    func setToken(_ newToken: Token?, for tokenType: TokenType, username: String) async throws {
        guard let newToken = newToken, let data = try? JSONEncoder().encode(newToken) else { return }
        let service = "\(username)-\(tokenType.rawValue)"
        let account = "\(username)-account"
        AppLogger.shared.info("Saving token in \(service)")
        try await keychainManager.saveKeyChain(data, for: service, account: account)
    }
}
