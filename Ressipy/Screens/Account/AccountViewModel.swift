//
//  AccountViewModel.swift
//  AccountViewModel
//
//  Created by Dennis Beatty on 8/9/21.
//

import Foundation

class AccountViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userEmail: String? = nil
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAuthUpdate), name: .didUpdateAuth, object: nil)
        
        isLoggedIn = AuthManager.shared.isLoggedIn
        
        if isLoggedIn {
            userEmail = AuthManager.shared.userEmail
        }
    }
    
    @objc private func onAuthUpdate(_ notification: Notification) {
        isLoggedIn = AuthManager.shared.isLoggedIn
        if isLoggedIn { userEmail = AuthManager.shared.userEmail }
    }
    
    func signOut() {
        AuthManager.shared.deauthenticate()
        isLoggedIn = false
        userEmail = nil
    }
}
