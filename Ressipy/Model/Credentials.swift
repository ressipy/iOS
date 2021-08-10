//
//  Credentials.swift
//  Credentials
//
//  Created by Dennis Beatty on 8/8/21.
//

import Foundation

struct CredentialsWrapper: Encodable {
    let user: Credentials
}

struct Credentials: Encodable {
    let email: String
    let password: String
}
