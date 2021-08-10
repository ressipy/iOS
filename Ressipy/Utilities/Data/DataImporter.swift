//
//  DataImporter.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/13/21.
//
//  This was mostly done with the help of Donny Wals' article
//  https://www.donnywals.com/implementing-a-one-way-sync-strategy-with-core-data-urlsession-and-combine/
//

import Combine
import CoreData
import Foundation
import os

struct ImporterResponse: Decodable {
    let deleted: ImporterResponse.Deleted
    let categories: [Category]
    let fetchedAt: String
    let recipes: [Recipe]
}

extension ImporterResponse {
    struct Deleted: Decodable {
        let categories: [String]
        let recipes: [String]
    }
}

class DataImporter {
    static let shared = DataImporter()
    
    var cancellables = Set<AnyCancellable>()
    let importContext: NSManagedObjectContext
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "DataImporter")
    
    var lastSyncedAt: String? {
        get { UserDefaults.standard.string(forKey: "DataImporter.lastSyncedAt") }
        set { UserDefaults.standard.set(newValue, forKey: "DataImporter.lastSyncedAt")}
    }
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = importContext
        return decoder
    }()
    
    private init() {
        importContext = StorageProvider.shared.persistentContainer.newBackgroundContext()
        importContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func runImport() {
        NetworkManager.shared.getSyncData(updatedAfter: self.lastSyncedAt) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.importContext.perform {
                    self.lastSyncedAt = response.fetchedAt
                    
                    let _ = response.categories.map { $0.toEntity(context: self.importContext) }
                    let _ = response.recipes.map { $0.toEntity(context: self.importContext) }
                    
                    let deletedRecipesPredicate = NSPredicate(format: "slug IN %@", response.deleted.recipes)
                    let deletedRecipesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
                    deletedRecipesRequest.predicate = deletedRecipesPredicate
                    let batchDeleteRecipes = NSBatchDeleteRequest(fetchRequest: deletedRecipesRequest)
                    
                    let deletedCategoriesPredicate = NSPredicate(format: "slug IN %@", response.deleted.categories)
                    let deletedCategoriesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
                    deletedCategoriesRequest.predicate = deletedCategoriesPredicate
                    let batchDeleteCategories = NSBatchDeleteRequest(fetchRequest: deletedCategoriesRequest)
                    
                    do {
                        try self.importContext.execute(batchDeleteRecipes)
                        try self.importContext.execute(batchDeleteCategories)
                        
                        try self.importContext.save()
                    } catch {
                        self.logger.error("Data import failed: \(String(describing: error))")
                    }
                }
            case .failure(let error):
                self.logger.error("Data import failed: \(String(describing: error))")
            }
        }
    }
}
