//
//  Recipe.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import CoreData
import Foundation

struct Recipe: Codable {
    let author: String?
    let category: Category?
    let ingredients: [Ingredient]?
    let instructions: [Instruction]?
    let name: String
    let slug: String
    
    private enum EncodingKeys: String, CodingKey {
        case author, ingredients, instructions, name
        case categorySlug
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(author, forKey: .author)
        try container.encode(category?.slug, forKey: .categorySlug)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(name, forKey: .name)
    }
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
    
    func toEntity(context: NSManagedObjectContext, includeCategory: Bool = true) -> RecipeEntity {
        let entity = RecipeEntity(context: context)
        
        entity.author = author
        entity.name = name
        entity.ingredients = ingredients
        entity.instructions = instructions
        entity.slug = slug
        
        if let category = category, includeCategory { entity.category = category.toEntity(context: context) }
        
        return entity
    }
}
