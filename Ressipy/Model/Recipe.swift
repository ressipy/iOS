//
//  Recipe.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import CoreData
import Foundation

class Recipe: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case author, ingredients, instructions, name, slug
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.slug = try container.decode(String.self, forKey: .slug)
        
        if container.contains(.author) {
        self.author = try container.decode(String.self, forKey: .author)
        }
        
        if container.contains(.ingredients) {
            self.ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
        }
        
        if container.contains(.instructions) {
            self.instructions = try container.decode([Instruction].self, forKey: .instructions)
        }
    }
}
