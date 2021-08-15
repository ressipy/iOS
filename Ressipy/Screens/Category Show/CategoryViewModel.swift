//
//  CategoryViewModel.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject, NewRecipeViewModelDelegate {
    @Published var allowDelete = false
    @Published var category: Category?
    @Published var isLoading = false
    @Published var showNewRecipeButton = false
    @Published var showNewRecipeForm = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        
        if AuthManager.shared.permissions?.createRecipe == true {
            showNewRecipeButton = true
        }
        
        if AuthManager.shared.permissions?.deleteRecipe == true {
            allowDelete = true
        }
    }
    
    func getCategory(slug: String) {
        DispatchQueue.main.async {
            guard !self.isLoading else { return }
            
            DataManager.shared.getCategory(slug: slug) { [weak self] category in
                guard let self = self else { return }
                
                self.category = category
                self.isLoading = false
            }
        }
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
    
    @objc func contextDidSave(_ notification: Notification) {
        if let slug = category?.slug {
            getCategory(slug: slug)
        }
    }
    
    func didSaveRecipe(_ recipe: Recipe) {
        if let slug = category?.slug {
            getCategory(slug: slug)
        }
        
        showNewRecipeForm = false
    }
    
    func displayNewRecipeForm() {
        if category == nil { return }
        showNewRecipeForm = true
    }
}
