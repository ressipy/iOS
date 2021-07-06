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
    }
}

