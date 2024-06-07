//
//  PasswordManagerApp.swift
//  PasswordManager
//
//  Created by Lochan on 07/06/24.
//

import SwiftUI
import SwiftData
import CryptoKit

func getWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}
func symmetricKeyToData(_ key: SymmetricKey) -> Data {
    return key.withUnsafeBytes { Data(Array($0)) }
}

func dataToSymmetricKey(_ data: Data) -> SymmetricKey {
    return SymmetricKey(data: data)
}

@main
struct PasswordManagerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
  
        }
        .modelContainer(for: Credentials.self)
    }
}
