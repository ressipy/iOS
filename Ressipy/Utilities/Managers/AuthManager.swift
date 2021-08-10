//
//  AuthManager.swift
//  AuthManager
//
//  Created by Dennis Beatty on 8/8/21.
//

import Foundation
import os

enum AuthenticationResult {
    case success
    case failure(AuthenticationError)
}

enum AuthenticationError: Error {
    case clientError
    case invalidCredentials
    case serverError
    case storageError
    case tooManyAttempts
}

class AuthManager {
    static let shared = AuthManager()
    
    private(set) var isLoggedIn = false
    private(set) var permissions: Permissions? = nil
    private(set) var token: String? = nil
    private(set) var userEmail: String? = nil
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AuthManager")
    private let tag = "com.ressipy.Ressipy.userToken".data(using: .utf8)!
    
    private init() {
        if let token = getToken() {
            self.isLoggedIn = true
            self.token = token
            self.permissions = getPermissions()
            self.userEmail = getEmail()
        }
    }
    
    func authenticate(credentials: Credentials, completion: @escaping (AuthenticationResult) -> ()) {
        NetworkManager.shared.createToken(credentials: credentials) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let tokenResult):
                let storeResult = self.setToken(tokenResult.token)
                
                switch storeResult {
                case .success:
                    self.setEmail(credentials.email)
                    self.setPermissions(tokenResult.permissions)
                    self.isLoggedIn = true
                    completion(.success)
                    NotificationCenter.default.post(name: .didAuthenticate, object: self)
                case .failure(let authenticationError):
                    completion(.failure(authenticationError))
                }
            case .failure(let error):
                switch error {
                case .requestRateLimited:
                    completion(.failure(.tooManyAttempts))
                case .requestUnauthorized:
                    completion(.failure(.invalidCredentials))
                case .badURL, .badRequest, .requestForbidden:
                    completion(.failure(.clientError))
                default:
                    completion(.failure(.serverError))
                }
            }
        }
    }
    
    func deauthenticate() {
        if removeToken() {
            removeEmail()
            removePermissions()
            self.isLoggedIn = false
        }
    }
    
    private func getEmail() -> String? {
        UserDefaults.standard.string(forKey: "emailAddress")
    }
    
    private func getPermissions() -> Permissions? {
        guard let data = UserDefaults.standard.value(forKey:"permissions") as? Data else { return nil }
        return try? JSONDecoder().decode(Permissions.self, from: data)
    }
    
    private func getToken() -> String? {
        var ref: AnyObject?
        
        let getQuery = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: tag,
            kSecReturnData: true
        ] as CFDictionary
        
        let status = SecItemCopyMatching(getQuery, &ref)
        
        if status != errSecSuccess {
            self.logger.error("User token fetch failed: \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)")
            return nil
        }
        
        if let result = ref as? Data {
            return String(data: result, encoding: .utf8)
        }
        
        return nil
    }
    
    private func removeEmail() {
        UserDefaults.standard.removeObject(forKey: "emailAddress")
        self.userEmail = nil
    }
    
    private func removePermissions() {
        UserDefaults.standard.removeObject(forKey: "permissions")
        self.permissions = nil
    }
    
    private func removeToken() -> Bool {
        let removeQuery = [
            kSecAttrApplicationTag: tag,
            kSecClass: kSecClassKey
        ] as CFDictionary
        
        let status = SecItemDelete(removeQuery)
        
        if status == errSecSuccess {
            self.token = nil
            return true
        } else {
            return false
        }
    }
    
    private func setEmail(_ email: String) {
        self.userEmail = email
        UserDefaults.standard.set(email, forKey: "emailAddress")
    }
    
    private func setPermissions(_ permissions: Permissions) {
        self.permissions = permissions
        UserDefaults.standard.set(try? JSONEncoder().encode(permissions), forKey:"permissions")
    }
    
    private func setToken(_ token: String) -> AuthenticationResult {
        let tokenData = token.data(using: .utf8, allowLossyConversion: false)!
        
        let addQuery = [
            kSecValueData: tokenData,
            kSecAttrApplicationTag: tag,
            kSecClass: kSecClassKey
        ] as CFDictionary
        
        let status = SecItemAdd(addQuery, nil)
        
        if status != errSecSuccess {
            self.logger.error("User token write failed: \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)")
            return .failure(AuthenticationError.storageError)
        }
        
        self.token = token
        return .success
    }
}
