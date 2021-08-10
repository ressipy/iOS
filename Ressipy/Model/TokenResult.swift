//
//  TokenResult.swift
//  TokenResult
//
//  Created by Dennis Beatty on 8/8/21.
//

import Foundation

struct TokenResult: Decodable {
    let permissions: Permissions
    let token: String
}
