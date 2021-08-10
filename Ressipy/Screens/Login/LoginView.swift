//
//  LoginView.swift
//  LoginView
//
//  Created by Dennis Beatty on 7/30/21.
//

import SwiftUI

struct PasswordField: View {
    @Binding var text: String
    @Binding var showPassword: Bool
    
    var body: some View {
        if showPassword {
            TextField("Password", text: $text)
        } else {
            SecureField("Password", text: $text)
        }
    }
}

struct LoginView: View {
    @StateObject var vm = LoginViewModel()
    
    var body: some View {
        VStack {
            Text("Sign in to your account")
                .font(.title)
                .fontWeight(.semibold)
            
            TextField("Email address", text: $vm.emailAddress)
                .textContentType(.username)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(12)
                .padding(.leading, 25)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            
            ZStack(alignment: .trailing) {
                PasswordField(text: $vm.password, showPassword: $vm.showPassword)
                    .textContentType(.password)
                    .padding(vm.showPassword ? 12 : 12.75)
                    .padding(.leading, 25)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "key")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                        }
                    )
                Button(action: {
                    vm.showPassword.toggle()
                }) {
                    Image(systemName: vm.showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            
            Button {
                vm.signIn()
            } label: {
                Text("Sign in")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 260, height: 50)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
