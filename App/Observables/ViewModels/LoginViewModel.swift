//
//  LoginViewModel.swift
//  Tumble
//
//  Created by Adis Veletanlic on 6/16/23.
//

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    @Inject private var preferenceService: PreferenceService
    @Inject private var userController: UserController
    @Inject private var schoolManager: SchoolManager
    
    @Published var attemptingLogin: Bool = false
    @Published var authSchoolId: Int = -1
    
    let popupFactory: PopupFactory = .shared
    lazy var schools: [School] = schoolManager.getSchools()
    
    func login(
        authSchoolId: Int,
        username: String,
        password: String,
        school: School
    ) async {
        defer {
            animateAuthentication(loggingIn: false)
        }
        do {
            animateAuthentication(loggingIn: true)
            try await userController.logIn(
                authSchoolId: authSchoolId,
                username: username,
                password: password,
                school: school
            )
            
            if userController.authStatus == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    PopupToast(popup: self.popupFactory.logInSuccess(as: username)).showAndStack()
                }
            }
        } catch {
            AppLogger.shared.error("Failed to log in user: \(error)")
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                PopupToast(popup: self.popupFactory.logInFailed()).showAndStack()
            }
        }
    }
    
    func animateAuthentication(loggingIn: Bool) {
        DispatchQueue.main.async { [weak self] in
            withAnimation {
                self?.attemptingLogin = false
            }
        }
    }
}
