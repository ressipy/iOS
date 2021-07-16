//
//  Recipe.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import CoreData
import Foundation

struct Recipe: Decodable {
    let author: String?
    let category: Category?
    let ingredients: [Ingredient]?
    let instructions: [Instruction]?
    let name: String
    let slug: String
}

extension Recipe: Identifiable {
    var id: String { return slug }
}

extension Recipe {
    init(entity: RecipeEntity, includeCategory: Bool = false) {
        author = entity.author
        category = includeCategory ? Category(entity: entity.category!) : nil
        ingredients = entity.ingredients
        instructions = entity.instructions
        name = entity.name!
        slug = entity.slug!
    }
    
    func toEntity(context: NSManagedObjectContext) -> RecipeEntity {
        let entity = RecipeEntity(context: context)
        
        entity.author = author
        entity.name = name
        entity.ingredients = ingredients
        entity.instructions = instructions
        entity.slug = slug
        
        if let category = category { entity.category = category.toEntity(context: context) }
        
        return entity
    }
}
