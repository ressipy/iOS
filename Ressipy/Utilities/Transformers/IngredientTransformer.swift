//
//  IngredientTransformer.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/6/21.
//

import UIKit

class IngredientTransformer: ValueTransformer {
    // Convert an Ingredient to data for storage in our persistence layer
    override func transformedValue(_ value: Any?) -> Any? {
        guard let ingredients = value as? [Ingredient] else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: ingredients, requiringSecureCoding: false)
        } catch {
            print("Failed to encode ingredient list - \(error)")
            return nil
        }
    }
    
    // Convert data to an Ingredient for use in the application
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Ingredient]
        } catch {
            print("Failed to decode ingredient list - \(error)")
            return nil
        }
    }
}
