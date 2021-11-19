//
//  DataManager.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Combine
import CoreData
import Foundation
import os

class DataManager {
    static let shared = DataManager()
    let updateContext: NSManagedObjectContext
    var cancellables = Set<AnyCancellable>()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "DataManager")
    
    private init() {
        updateContext = StorageProvider.shared.persistentContainer.viewContext
        updateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func createRecipe(recipe: Recipe, completion: @escaping (Result<Recipe, NetworkError>) -> ()) {
        NetworkManager.shared.createRecipe(recipe: recipe) { recipeResult in
            switch recipeResult {
            case .success(let recipeWrapper):
                self.updateContext.perform {
                    let _ = recipeWrapper.recipe.toEntity(context: self.updateContext)
                    
                    do {
                        try self.updateContext.save()
                    } catch {
                        self.logger.error("Saving new recipe to Core Data failed: \(String(describing: error))")
                    }
                }
                
                completion(.success(recipeWrapper.recipe))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteRecipe(recipe: Recipe, completion: @escaping (Result<Recipe, NetworkError>) -> ()) {
        NetworkManager.shared.deleteRecipe(slug: recipe.slug) { deleteResult in
            switch deleteResult {
            case .success(let recipeWrapper):
                self.updateContext.perform {
                    let deletedRecipeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
                    deletedRecipeRequest.predicate = NSPredicate(format: "slug = %@", recipeWrapper.recipe.slug)
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deletedRecipeRequest)
                    
                    do {
                        try self.updateContext.execute(deleteRequest)
                    } catch {
                        self.logger.error("Failed to delete recipe from Core Data: \(String(describing: error))")
                    }
                }
                
                completion(.success(recipeWrapper.recipe))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCategory(slug: String, completion: @escaping (Category) -> ()) {
//        NetworkManager.shared.getCategory(slug: slug) { categoryResult in
//            completion(categoryResult.category)
//        }
        let category = StorageProvider.shared.getCategory(slug: slug)!
        completion(category)
    }
    
    func getCategoryList(completion: @escaping ([Category]) -> ()) {
//        NetworkManager.shared.getCategoryList() { categoryListResult in
//            completion(categoryListResult.categories)
//        }
        
        let categories = StorageProvider.shared.getCategoryList()!
        completion(categories)
    }
    
    func getRecipe(slug: String, completion: @escaping (Recipe) -> ()) {
//        NetworkManager.shared.getRecipe(slug: slug) { recipeResult in
//            completion(recipeResult.recipe)
//        }
        let recipe = StorageProvider.shared.getRecipe(slug: slug)!
        completion(recipe)
    }
    
    func updateRecipe(recipe: Recipe, completion: @escaping (Result<Recipe, NetworkError>) -> ()) {
        NetworkManager.shared.updateRecipe(recipe: recipe) { recipeResult in
            switch recipeResult {
            case .success(let recipeWrapper):
                self.updateContext.perform {
                    let _ = recipeWrapper.recipe.toEntity(context: self.updateContext)
                    
                    do {
                        try self.updateContext.save()
                    } catch {
                        self.logger.error("Saving updated recipe to Core Data failed: \(String(describing: error))")
                    }
                }
                
                completion(.success(recipeWrapper.recipe))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
