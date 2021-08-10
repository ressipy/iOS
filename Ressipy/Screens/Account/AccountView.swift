//
//  AccountView.swift
//  AccountView
//
//  Created by Dennis Beatty on 8/9/21.
//

import SwiftUI

struct AccountView: View {
    @StateObject var vm = AccountViewModel()
    
    var body: some View {
        VStack {
            if vm.isLoggedIn {
                Text("You're logged in as")
                    .font(.subheadline)
                    .padding(.top, 180)
                
                Text(vm.userEmail!)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 2)
                
                Spacer()
                
                Button {
                    vm.signOut()
                } label: {
                    Text("Sign out")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 260, height: 50)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom, 64)
            } else {
                LoginView()
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(vm: createViewModel())
    }
    
    static func createViewModel() -> AccountViewModel {
        let viewModel = AccountViewModel()
        viewModel.userEmail = "test.email@testdomain.com"
        viewModel.isLoggedIn = true
        return viewModel
    }
}
