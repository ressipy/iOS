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
                Text("You're logged in as \(vm.userEmail!)")
                
                Button {
                    vm.signOut()
                } label: {
                    Text("Sign out")
                }
            } else {
                LoginView()
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
