//
//  Category.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import CoreData

struct Category: Codable {
    let name: String
    let recipes: [Recipe]?
    let slug: String
}

extension Category: Identifiable {
    var id: String { return slug }
}

extension Category {
    init(entity: CategoryEntity, includeRecipes: Bool = false) {
        name = entity.name ?? ""
        slug = entity.slug ?? ""
        
        if includeRecipes, let recipeEntities = entity.recipes {
            let sortDescriptors = [NSSortDescriptor(key: "slug", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
            recipes = recipeEntities.sortedArray(using: sortDescriptors).map { recipeEntity in
                Recipe(entity: recipeEntity as! RecipeEntity)
            }
        } else {
            recipes = nil
        }
    }
    
    func toEntity(context: NSManagedObjectContext) -> CategoryEntity {
        let entity = CategoryEntity(context: context)
        entity.name = name
        entity.slug = slug
        
        if let recipes = recipes {
            let recipeEntities = recipes.map { $0.toEntity(context: context) }
            entity.recipes = Set(arrayLiteral: recipeEntities) as NSSet
        }
        
        return entity
    }
}
