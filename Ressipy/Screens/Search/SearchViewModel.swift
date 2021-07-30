//
//  SearchViewModel.swift
//  SearchViewModel
//
//  Created by Dennis Beatty on 7/29/21.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchResults: [Recipe] = []
    @Published var showCancel = false
    @Published var searchText = "" {
        didSet {
            searchRecipes()
        }
    }
    
    func searchRecipes() {
        guard !searchText.isEmpty else { return }
        
        if let results = StorageProvider.shared.searchRecipes(searchText) {
            searchResults = results
        }
    }
}
