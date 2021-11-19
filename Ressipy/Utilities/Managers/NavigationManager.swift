//
//  NavigationManager.swift
//  NavigationManager
//
//  Created by Dennis Beatty on 8/23/21.
//

import Foundation

class NavigationManager: ObservableObject {
    @Published var activeTab = RessipyTabView.Tab.recipes
    @Published var categorySlug: String?
    @Published var recipeSlug: String?
    
    static let shared = NavigationManager()
    
    private init() {}
    
    func openCategory(slug: String) {
        categorySlug = slug
    }
    
    func openRecipe(slug: String) {
        DataManager.shared.getRecipe(slug: slug) { recipe in
            self.categorySlug = recipe.category?.slug
            self.recipeSlug = slug
        }
    }
}
