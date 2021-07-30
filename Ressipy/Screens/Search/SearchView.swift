//
//  SearchView.swift
//  SearchView
//
//  Created by Dennis Beatty on 7/29/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $vm.searchText) { _ in
                        if !vm.searchText.isEmpty { vm.showCancel = true }
                    }
                    .padding(8)
                    .padding(.leading, 25)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        vm.showCancel = true
                    }
                    
                    if vm.showCancel == true {
                        Button(action: {
                            vm.showCancel = false
                            vm.searchText = ""
                            hideKeyboard()
                            vm.searchResults = []
                        }, label: {
                            Text("Cancel")
                        })
                            .padding(.trailing, 20)
                            .transition(.move(edge: .trailing))
                            .animation(.default)
                    }
                }
                
                RecipeList(recipes: vm.searchResults)
                
                Spacer()
            }
            .navigationTitle("Search")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
