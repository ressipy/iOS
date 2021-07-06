//
//  CategoryListViewModel.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import Combine

class CategoryListViewModel: ObservableObject {
    @Published var categories = [Category]()
    @Published var isLoading = true
    
    init() {
        DataManager.shared.getCategoryList { [weak self] categoryListResult in
            guard let self = self else { return }
            
            self.categories = categoryListResult.categories
            self.isLoading = false
        }
    }
}
