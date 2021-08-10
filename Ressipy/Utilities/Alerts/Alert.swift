//
//  Alert.swift
//  Alert
//
//  Created by Dennis Beatty on 8/8/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    // MARK: - Login Alerts
    
    static let invalidForm = AlertItem(title: Text("Invalid form"),
                                       message: Text("Please ensure all fields in the form have been filled out."),
                                       dismissButton: .default(Text("OK")))
    
    static let invalidEmail = AlertItem(title: Text("Invalid email"),
                                        message: Text("Please make sure your email address is correct."),
                                        dismissButton: .default(Text("OK")))
    
    static let invalidLogin = AlertItem(title: Text("Invalid credentials"),
                                        message: Text("The username or password you entered was incorrect."),
                                        dismissButton: .default(Text("OK")))
    
    static let tooManyLoginAttempts = AlertItem(title: Text("Too many attempts"),
                                                message: Text("You have attempted to sign in too many times. Please wait before trying again."),
                                                dismissButton: .default(Text("OK")))
    
    static let serverError = AlertItem(title: Text("Server error"),
                                       message: Text("There was an unexpected error when logging in. Please try again."),
                                       dismissButton: .default(Text("OK")))
}

