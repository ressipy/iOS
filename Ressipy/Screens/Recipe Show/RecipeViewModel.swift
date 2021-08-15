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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onAuthUpdate), name: .didUpdateAuth, object: nil)
        
        getRecipe()
        setPermissions()
    }
    
    var enumeratedInstructions: [(Int, Instruction)] {
        let instructions = recipe?.instructions ?? []
        return Array(instructions.enumerated())
    }
    
    func displayEditForm() {
        if recipe == nil { return }
        showEditForm = true
    }
    
    // MARK: Private functions
    
    private func getRecipe() {
        guard !isLoading else { return }
        isLoading = true
        
        DataManager.shared.getRecipe(slug: slug) { [weak self] recipe in
            guard let self = self else { return }
            
            self.recipe = recipe
            self.isLoading = false
        }
    }
    
    @objc private func onAuthUpdate(_: Notification) {
        setPermissions()
    }
    
    private func setPermissions() {
        self.showEditButton = AuthManager.shared.permissions?.updateRecipe == true
    }
}

extension RecipeViewModel: NewRecipeViewModelDelegate {
    func didSaveRecipe(_ recipe: Recipe) {
        getRecipe()
        showEditForm = false
    }
}
