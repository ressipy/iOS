//
//  DataManager.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Combine
import Foundation

class DataManager {
    static let shared = DataManager()
    var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func getCategory(slug: String, completion: @escaping (Category) -> ()) {
        NetworkManager.shared.getCategory(slug: slug) { categoryResult in
            completion(categoryResult.category)
        }
    }
    
    func getCategoryList(completion: @escaping ([Category]) -> ()) {
        NetworkManager.shared.getCategoryList() { categoryListResult in
            completion(categoryListResult.categories)
        }
    }
    
    func getRecipe(slug: String, completion: @escaping (Recipe) -> ()) {
        NetworkManager.shared.getRecipe(slug: slug) { recipeResult in
            completion(recipeResult.recipe)
        }
    }
}
