import Foundation

actor KeyChainManager {
    enum KeyChainManagerError: Swift.Error {
        case generic(reason: String)
    }

    func updateKeyChain(_ data: Data, for service: String, account: String) throws {
        let query: CFDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        let attributes: CFDictionary = [kSecValueData: data] as CFDictionary

        let status = SecItemUpdate(query, attributes)
        guard status == errSecSuccess else {
            throw KeyChainManagerError.generic(reason: "Failed to update keychain item. Status: \(status)")
        }
    }
    
    func deleteKeyChain(for service: String, account: String) throws {
        let query: CFDictionary = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
            
        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainManagerError.generic(reason: "Failed to delete keychain item. Status: \(status)")
        }
        
        AppLogger.shared.debug("Deleted item from keychain for service: \(service), account: \(account)")
    }
    
    func readKeyChain(for service: String, account: String) throws -> Data? {
        let query: CFDictionary = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess else {
            throw KeyChainManagerError.generic(reason: "Failed to read keychain item. Status: \(status)")
        }
        return result as? Data
    }
    
    func saveKeyChain(_ data: Data, for service: String, account: String) throws {
        let query: CFDictionary = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
            
        let status = SecItemAdd(query, nil)
        if status == errSecDuplicateItem {
            try updateKeyChain(data, for: service, account: account)
            return
        }
        
        guard status == errSecSuccess else {
            AppLogger.shared.error("Could not save item to keychain. Status: \(status)")
            throw KeyChainManagerError.generic(reason: "Could not save item to keychain. Status: \(status)")
        }
        
        AppLogger.shared.debug("Added item to keychain for service: \(service), account: \(account)")
    }
}
