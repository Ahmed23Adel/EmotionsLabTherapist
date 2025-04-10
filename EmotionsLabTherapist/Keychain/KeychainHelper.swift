//
//  KeychainHelper.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import Foundation
import Security


struct KeychainHelper {
    static let shared = KeychainHelper()
    private init(){}
    
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary
    
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return result as? Data
    }

    func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        SecItemDelete(query)
    }
    
    func clearAll() {
        let query = [kSecClass: kSecClassGenericPassword] as CFDictionary
        SecItemDelete(query)
    }

}

