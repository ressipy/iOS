//
//  RessipyTabView.swift
//  RessipyTabView
//
//  Created by Dennis Beatty on 7/29/21.
//

import SwiftUI

struct RessipyTabView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    
    var body: some View {
        TabView(selection: $navigationManager.activeTab) {
            CategoryListView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Recipes")
                }
                .tag(Tab.recipes)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(Tab.search)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
                .tag(Tab.account)
        }
    }
}

extension RessipyTabView {
    enum Tab: Hashable {
        case recipes
        case search
        case account
    }
}

struct RessipyTabView_Previews: PreviewProvider {
    static var previews: some View {
        RessipyTabView()
    }
}
