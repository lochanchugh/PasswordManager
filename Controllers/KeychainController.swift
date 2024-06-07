//
//  KeychainManager.swift
//  PasswordManager
//
//  Created by Lochan on 07/06/24.
//

import Foundation
import CryptoKit
import KeychainSwift

class KeychainController {
    let keychain = KeychainSwift()
    private var key: SymmetricKey
    
    init() {
        if let savedKey = keychain.getData("encryptionKey") {
            self.key = dataToSymmetricKey(savedKey)
            print("Key Exists")
            print(key)
        } else {
            let symmetricKey = SymmetricKey(size: .bits256)
            keychain.set(symmetricKeyToData(symmetricKey), forKey: "encryptionKey")
            self.key = symmetricKey
            print("New key Saved")
        }
    }
    func encryptData(password: String) -> String {
        guard let data = password.data(using: .utf8) else {
            return "Failed to encrypt data"
        }
        let sealedBox = try! AES.GCM.seal(data, using: key)
        return (sealedBox.combined?.base64EncodedString())!
    }
    
    func decryptData(data: String) -> String {
        guard let data = Data(base64Encoded: data) else {
            return "Failed to decrypt data"
        }
        let sealedBox = try! AES.GCM.SealedBox(combined: data)
        let decryptedData = try! AES.GCM.open(sealedBox, using: key)
        guard let text = String(data: decryptedData, encoding: .utf8) else {
            return "Failed to decrypt data"
        }
        return text
    }
}
