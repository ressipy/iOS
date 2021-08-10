//
//  RessipyTabView.swift
//  RessipyTabView
//
//  Created by Dennis Beatty on 7/29/21.
//

import SwiftUI

struct RessipyTabView: View {
    var body: some View {
        TabView {
            CategoryListView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Recipes")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
}

struct RessipyTabView_Previews: PreviewProvider {
    static var previews: some View {
        RessipyTabView()
    }
}
