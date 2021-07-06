//
//  Category.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import CoreData

class Category: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case name, recipes, slug
    }
    
    public var recipeArray: [Recipe] {
        let set = recipes as? Set<Recipe> ?? []
        return set.sorted { $0.slug! < $1.slug! }
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.slug = try container.decode(String.self, forKey: .slug)
        
        if container.contains(.recipes) {
            self.recipes = try container.decode(Set<Recipe>.self, forKey: .recipes) as NSSet
        }
    }
}
