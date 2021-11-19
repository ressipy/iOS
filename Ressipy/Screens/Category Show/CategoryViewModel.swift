//
//  CategoryViewModel.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject {
    @Published var allowDelete = false
    @Published var category: Category?
    @Published var isLoading = false
    @Published var recipes = [Recipe]()
    @Published var showNewRecipeButton = false
    @Published var showNewRecipeForm = false
    
    var slug: String
    
    init(slug: String) {
        self.slug = slug
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave), name: .NSManagedObjectContextDidSave, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAuthUpdate), name: .didUpdateAuth, object: nil)

        setPermissions()
        getCategory()
    }
    
    func deleteRecipes(at offsets: IndexSet) {
        if let recipes = category?.recipes {
            for offset in offsets {
                let recipe = recipes[offset]
                DataManager.shared.deleteRecipe(recipe: recipe) { _ in }
            }
            
            category!.recipes!.remove(atOffsets: offsets)
        }
    }
    
    func displayNewRecipeForm() {
        if category == nil { return }
        showNewRecipeForm = true
    }
    
    // MARK: Private functions
    
    private func getCategory() {
        guard !isLoading else { return }
        isLoading = true
        
        DataManager.shared.getCategory(slug: slug) { [weak self] category in
            guard let self = self, let recipes = category.recipes else { return }
            
            self.category = category
            self.recipes = recipes
            self.isLoading = false
        }
    }
    
    @objc private func contextDidSave(_ notification: Notification) {
        getCategory()
    }
    
    @objc private func onAuthUpdate(_ notification: Notification) {
        setPermissions()
    }
        
    private func setPermissions() {
        showNewRecipeButton = AuthManager.shared.permissions?.createRecipe == true
        allowDelete = AuthManager.shared.permissions?.deleteRecipe == true
    }
}

extension CategoryViewModel: NewRecipeViewModelDelegate {
    func didSaveRecipe(_ recipe: Recipe) {
        guard category != nil else { return }
        
        getCategory()
        showNewRecipeForm = false
    }
}
