//
//  Credential.swift
//  PasswordManager
//
//  Created by Lochan on 07/06/24.
//

import Foundation
import SwiftData

@Model
class Credentials {
    var account: String
    var username: String
    var password: String
    
    init(account: String, username: String, password: String) {
        self.account = account
        self.username = username
        self.password = password
    }
}
