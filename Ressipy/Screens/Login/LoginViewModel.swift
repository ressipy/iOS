//
//  LoginViewModel.swift
//  LoginViewModel
//
//  Created by Dennis Beatty on 8/8/21.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var showPassword = false
    
    var isValidForm: Bool {
        guard !emailAddress.isEmpty && !password.isEmpty else {
            alertItem = AlertContext.invalidForm
            return false
        }
        
        guard emailAddress.isValidEmail else {
            alertItem = AlertContext.invalidEmail
            return false
        }
        
        return true
    }
    
    func signIn() {
        guard isValidForm else { return }
        
        let credentials = Credentials(email: emailAddress, password: password)
        AuthManager.shared.authenticate(credentials: credentials) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                return
            case .failure(let error):
                switch error {
                case .clientError:
                    self.alertItem = AlertContext.serverError
                case .invalidCredentials:
                    self.alertItem = AlertContext.invalidLogin
                case .serverError:
                    self.alertItem = AlertContext.serverError
                case .tooManyAttempts:
                    self.alertItem = AlertContext.tooManyLoginAttempts
                case .storageError:
                    self.alertItem = AlertContext.serverError
                }
            }
        }
    }
}
