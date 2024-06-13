//
//  UserDefaultsService.swift
//  Tumble
//
//  Created by Adis Veletanlic on 11/16/22.
//

import Foundation
import SwiftUI

class PreferenceService {
    @Published var userOnBoarded: Bool = false
    @Published var autoSignupEnabled: Bool = false
    @Published var allUserAccounts: [String:Int] = [:]
    
    init() {
        userOnBoarded = isKeyPresentInUserDefaults(key: StoreKey.userOnboarded.rawValue)
        autoSignupEnabled = getAutoSignup()
        allUserAccounts = getAllUserAccounts()
    }
    
    // ----------- SET -----------
    
    func setUserAccount(username: String, authSchoolId: Int) {
        var allUserAccounts = UserDefaults.standard.dictionary(forKey: StoreKey.allUserAccounts.rawValue) as? [String:Int] ?? [String:Int]()
        
        allUserAccounts[username] = authSchoolId
        UserDefaults.standard.set(allUserAccounts, forKey: StoreKey.allUserAccounts.rawValue)
        UserDefaults.standard.synchronize()
        
        self.allUserAccounts = allUserAccounts
    }
    
    func updateMostRecentUser(to username: String) {
        UserDefaults.standard.set(username, forKey: StoreKey.lastUser.rawValue)
        UserDefaults.standard.synchronize()
        AppLogger.shared.info("Updated user to \(username)")
    }
    
    func removeUserAccount(username: String) {
        if var allUserAccounts = UserDefaults.standard.dictionary(forKey: StoreKey.allUserAccounts.rawValue) as? [String:Int] {
            allUserAccounts.removeValue(forKey: username)
            UserDefaults.standard.set(allUserAccounts, forKey: StoreKey.allUserAccounts.rawValue)
            self.allUserAccounts = allUserAccounts
            
            if username == getLastUser(), let newUser = allUserAccounts.first?.key {
                updateMostRecentUser(to: newUser)
            }
            
            UserDefaults.standard.synchronize()
            self.allUserAccounts = allUserAccounts
        }
    }

    func removeMostRecentUser() {
        let userDefaults = UserDefaults.standard
        let allUserAccountsKey = StoreKey.allUserAccounts.rawValue

        if var allUserAccounts = userDefaults.dictionary(forKey: allUserAccountsKey) as? [String:Int] {
            if !allUserAccounts.isEmpty, let lastUser = getLastUser() {
                allUserAccounts.removeValue(forKey: lastUser)
                userDefaults.set(allUserAccounts, forKey: allUserAccountsKey)

                if let newMostRecentUser = allUserAccounts.first?.key {
                    userDefaults.set(newMostRecentUser, forKey: StoreKey.lastUser.rawValue)
                } else {
                    userDefaults.removeObject(forKey: StoreKey.lastUser.rawValue)
                }

                userDefaults.synchronize()
                self.allUserAccounts = allUserAccounts
            }
        }
    }

    
    func setUserOnboarded() {
        UserDefaults.standard.set(true, forKey: StoreKey.userOnboarded.rawValue)
        userOnBoarded = true
        UserDefaults.standard.synchronize()
    }
    
    func setOffset(offset: Int) {
        UserDefaults.standard.set(offset, forKey: StoreKey.notificationOffset.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setAppearance(appearance: String) {
        UserDefaults.standard.set(appearance, forKey: StoreKey.appearance.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setLang(lang: String) {
        UserDefaults.standard.set(lang, forKey: StoreKey.locale.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setAutoSignup(autoSignup: Bool) {
        autoSignupEnabled = autoSignup
        UserDefaults.standard.set(autoSignup, forKey: StoreKey.autoSignup.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setViewType(viewType: Int) {
        UserDefaults.standard.set(viewType, forKey: StoreKey.viewType.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setLastUpdated(time: Date) {
        UserDefaults.standard.set(time, forKey: StoreKey.lastUpdated.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func setShowOneTimePopup(show: Bool = false) {
        UserDefaults.standard.set(show, forKey: StoreKey.showOneTimePopup.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    // ----------- GET -----------
    func getDefault(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    func getLastUser() -> String? {
        return UserDefaults.standard.string(forKey: StoreKey.lastUser.rawValue)
    }
    
    func getAllUserAccounts() -> [String:Int] {
        return UserDefaults.standard.dictionary(forKey: StoreKey.allUserAccounts.rawValue) as? [String:Int] ?? [String:Int]()
    }
    
    func getLastUpdated() -> Date? {
        return UserDefaults.standard.object(forKey: StoreKey.lastUpdated.rawValue) as? Date
    }
    
    func showOneTimePopup() -> Bool {
        return UserDefaults.standard.object(forKey: StoreKey.showOneTimePopup.rawValue) as? Bool ?? true
    }
    
    func getDefaultViewType() -> ViewType {
        let hasView: Bool = isKeyPresentInUserDefaults(key: StoreKey.viewType.rawValue)
        if !hasView {
            setViewType(viewType: 0)
            return ViewType.allCases[0]
        }
        
        let viewType: Int = getDefault(key: StoreKey.viewType.rawValue) as! Int
        return ViewType.allCases[viewType]
    }
    
    func getAuthSchoolForUsername(_ username: String) -> Int? {
        let userAccounts = getAllUserAccounts()
        print(userAccounts)
        return userAccounts[username]
    }
    
    func getNotificationOffset() -> Int {
        let hasOffset: Bool = isKeyPresentInUserDefaults(key: StoreKey.notificationOffset.rawValue)
        if !hasOffset {
            setOffset(offset: 60)
            return 60
        }
        return getDefault(key: StoreKey.notificationOffset.rawValue) as! Int
    }
    
    func getAutoSignup() -> Bool {
        if let autoSignup = getDefault(key: StoreKey.autoSignup.rawValue) as? Bool {
            return autoSignup
        }
        return false
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
