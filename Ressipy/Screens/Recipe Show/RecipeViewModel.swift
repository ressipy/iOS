//
//  RecipeViewModel.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var recipe: Recipe?
    @Published var showEditButton = false
    @Published var showEditForm = false
    
    var slug: String
    
    init(slug: String) {
        self.slug = slug
        getRecipe()
        
        if AuthManager.shared.permissions?.updateRecipe == true {
            self.showEditButton = true
        }
    }
    
    var enumeratedInstructions: [(Int, Instruction)] {
        let instructions = recipe?.instructions ?? []
        return Array(instructions.enumerated())
    }
    
    func displayEditForm() {
        if recipe == nil { return }
        showEditForm = true
    }
    
    func getRecipe() {
        guard !isLoading else { return }
        isLoading = true
        
        DataManager.shared.getRecipe(slug: slug) { [weak self] recipe in
            guard let self = self else { return }
            
            self.recipe = recipe
            self.isLoading = false
        }
    }
}

extension RecipeViewModel: NewRecipeViewModelDelegate {
    func didSaveRecipe(_ recipe: Recipe) {
        getRecipe()
        showEditForm = false
    }
}
