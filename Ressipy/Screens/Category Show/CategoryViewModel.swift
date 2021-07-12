//
//  CategoryViewModel.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject {
    @Published var category: Category?
    @Published var isLoading = false
    
    func getCategory(slug: String) {
        guard category == nil && !isLoading else { return }
        
        DataManager.shared.getCategory(slug: slug) { [weak self] category in
            guard let self = self else { return }
            
            self.category = category
            self.isLoading = false
        }
    }
}
