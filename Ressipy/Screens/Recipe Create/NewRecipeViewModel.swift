//
//  NewRecipeViewModel.swift
//  NewRecipeViewModel
//
//  Created by Dennis Beatty on 8/10/21.
//

import Foundation
import SwiftUI

protocol NewRecipeViewModelDelegate: AnyObject {
    func didSaveRecipe(_ recipe: Recipe)
}

class NewRecipeViewModel: ObservableObject {
    @Published var alertItem: AlertItem? = nil
    @Published var author = ""
    @Published var buttonText = "Add recipe"
    @Published var category: Category
    @Published var categories = [Category]()
    @Published var ingredients = [Ingredient(amount: "", name: "")]
    @Published var instructions = [Instruction(text: "")]
    @Published var name = ""
    @Published var showCategoryPicker = false
    @Published var title = "New recipe"
    
    @Published var selectedCategorySlug = "" {
        didSet {
            if let index = categories.firstIndex(where: { $0.slug == selectedCategorySlug }) {
                category = categories[index]
            }
        }
    }
    
    var delegate: NewRecipeViewModelDelegate
    var recipe: Recipe? = nil
    
    var areIngredientsValid: Bool {
        var empty = true
        
        for ingredient in ingredients {
            if !ingredient.amount.isEmpty && !ingredient.name.isEmpty { empty = false }
            else if !ingredient.amount.isEmpty || !ingredient.name.isEmpty { return false }
        }
        
        return !empty
    }
    var areInstructionsValid: Bool {
        var empty = true
        
        for instruction in instructions {
            if !instruction.text.isEmpty { empty = false }
        }
        
        return !empty
    }
    
    var isValidForm: Bool {
        guard !name.isEmpty else { return false }
        guard areInstructionsValid else { return false }
        
        return true
    }
    
    // MARK: Initializers
    
    init(category: Category, delegate: NewRecipeViewModelDelegate) {
        self.category = category
        self.delegate = delegate
        self.selectedCategorySlug = category.slug
        
        DataManager.shared.getCategoryList { categories in
            self.categories = categories
        }
    }
    
    init(recipe: Recipe, delegate: NewRecipeViewModelDelegate) {
        author = recipe.author ?? ""
        category = recipe.category!
        ingredients = recipe.ingredients ?? []
        instructions = recipe.instructions ?? []
        name = recipe.name
        
        buttonText = "Save recipe"
        selectedCategorySlug = recipe.category!.slug
        title = "Edit recipe"
        
        self.delegate = delegate
        self.recipe = recipe
        
        DataManager.shared.getCategoryList { categories in
            self.categories = categories
        }
    }
    
    // MARK: Methods
    
    func addIngredient() {
        ingredients.append(Ingredient(amount: "", name: ""))
    }
    
    func addInstruction() {
        let instruction = Instruction(text: "")
        instructions.append(instruction)
    }
    
    func saveRecipe() {
        guard isValidForm else {
            alertItem = AlertContext.invalidForm
            return
        }
        
        createOrUpdateRecipe { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let createdRecipe):
                self.delegate.didSaveRecipe(createdRecipe)
                return
            case .failure(let error):
                switch error {
                default:
                    self.alertItem = AlertContext.serverError
                }
            }
        }
    }
    
    /*
     MARK: Private methods
     */
    
    private func createOrUpdateRecipe(completion: @escaping (Result<Recipe, NetworkError>) -> ()) {
        if recipe == nil {
            createRecipe(completion: completion)
        } else {
            updateRecipe(completion: completion)
        }
    }
    
    private func createRecipe(completion: @escaping (Result<Recipe, NetworkError>) -> ()) {
        let authorInput = author.isEmpty ? nil : author
        
        let recipe = Recipe(author: authorInput, category: category, ingredients: ingredients, instructions: instructions, name: name, slug: "")
        
        DataManager.shared.createRecipe(recipe: recipe, completion: completion)
    }
    
    private func updateRecipe(completion: @escaping (Result<Recipe, NetworkError>) -> ()) {
        guard var recipe = recipe else { return }

        recipe.author = author.isEmpty ? nil : author
        recipe.category = category
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.name = name
        
        DataManager.shared.updateRecipe(recipe: recipe, completion: completion)
    }
}
