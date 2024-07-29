//
//  UniqueIdentifier.swift
//  Runner
//
//  Created by apple on 2024/7/15.
//

import Foundation
import Security

class UniqueIdentifier {
    private static let service = "com.qt.jx/plugin/device_id"
    private static let account = "device_id"
    
    static func getDeviceId() -> String {
        if let uniqueId = getKeychainItem(account: account) {
            return uniqueId
        }
        
        let deviceId = UUID().uuidString
        saveKeychainItem(account: account, value: deviceId)
        return deviceId
    }
    
    private static func getKeychainItem(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let data = item as? Data, let value = String(data: data, encoding: .utf8) {
                return value
            }
        }
        
        return nil
    }
    
    private static func saveKeychainItem(account: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
}
