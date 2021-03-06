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
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        loadCategories()
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        loadCategories()
    }
    
    func loadCategories() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = true
            
            DataManager.shared.getCategoryList { [weak self] categories in
                guard let self = self else { return }
                
                self.categories = categories
                self.isLoading = false
            }
        }
    }
}
