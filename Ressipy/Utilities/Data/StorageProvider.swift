//
//  StorageProvider.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/6/21.
//

import CoreData

class StorageProvider {
    static let shared = StorageProvider()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        ValueTransformer.setValueTransformer(IngredientTransformer(), forName: NSValueTransformerName("IngredientTransformer"))
        ValueTransformer.setValueTransformer(InstructionTransformer(), forName: NSValueTransformerName("InstructionTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        })
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func resetStore() {
        let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = CategoryEntity.fetchRequest()
        let categoryDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoryFetchRequest)
        let recipeFetchRequest: NSFetchRequest<NSFetchRequestResult> = RecipeEntity.fetchRequest()
        let recipeDeleteRequest = NSBatchDeleteRequest(fetchRequest: recipeFetchRequest)
        
        // perform the delete
        do {
            try persistentContainer.viewContext.execute(categoryDeleteRequest)
            try persistentContainer.viewContext.execute(recipeDeleteRequest)
        } catch let error as NSError {
            print(error)
        }

    }
}

extension StorageProvider {
    func getCategory(slug: String) -> Category? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "slug = %@", slug)
        fetchRequest.relationshipKeyPathsForPrefetching = ["recipes"]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let entity = result.first {
                return Category(entity: entity, includeRecipes: true)
            }
            
            print("No category found with slug: \(slug)")
            return nil
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
    
    func getCategoryList() -> [Category]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let categoryEntity = try context.fetch(fetchRequest)
            return categoryEntity.map { Category(entity: $0) }
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
    
    func getRecipe(slug: String) -> Recipe? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "slug = %@", slug)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let entity = result.first {
                return Recipe(entity: entity, includeCategory: true)
            }
            
            print("No recipe found with slug: \(slug)")
            return nil
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
    
    func searchRecipes(_ query: String) -> [Recipe]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let recipeEntities = try context.fetch(fetchRequest)
            return recipeEntities.map { Recipe(entity: $0) }
        } catch {
            print("Failed to search recipes: \(error)")
            return nil
        }
    }
}
