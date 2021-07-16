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
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    func getCategory(slug: String) {
        DispatchQueue.main.async {
            guard self.category == nil && !self.isLoading else { return }
            
            DataManager.shared.getCategory(slug: slug) { [weak self] category in
                guard let self = self else { return }
                
                self.category = category
                self.isLoading = false
            }
        }
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        if let slug = category?.slug {
            getCategory(slug: slug)
        }
    }
}
