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
    
    var slug: String
    
    init(slug: String) {
        self.slug = slug
    }
    
    var enumeratedInstructions: [(Int, Instruction)] {
        let instructions = recipe?.instructions ?? []
        return Array(instructions.enumerated())
    }
    
    func getRecipe() {
        guard !isLoading, recipe == nil else { return }
        isLoading = true
        
        DataManager.shared.getRecipe(slug: slug) { [weak self] recipe in
            guard let self = self else { return }
            
            self.recipe = recipe
            self.isLoading = false
        }
    }
}
