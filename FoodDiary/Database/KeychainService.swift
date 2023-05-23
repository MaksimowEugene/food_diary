import Security
import Foundation

public func saveDataToKeychain(value: String, forKey key: String) {
    let serviceName = "com.FoodDiary.data"
    guard let data = value.data(using: .utf8) else {
        print("Failed to convert data to string.")
        return
    }

    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: serviceName,
        kSecAttrAccount as String: key,
        kSecValueData as String: data
    ]

    let status = SecItemAdd(query as CFDictionary, nil)
    if status != errSecSuccess {
        print("Failed to save data to Keychain.")
    }
}

public func loadDataFromKeychain(forKey key: String) -> String? {
    let serviceName = "com.FoodDiary.data"

    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: serviceName,
        kSecAttrAccount as String: key,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnData as String: kCFBooleanTrue!
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
        return value
    } else {
        print("Failed to load data from Keychain.")
        return nil
    }
}
