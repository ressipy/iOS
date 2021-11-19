//
//  CategoryListView.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @StateObject var vm = CategoryListViewModel()
    
    init() {
        print("Initializing category list view")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(vm.categories) { category in
                        NavigationLink(destination: NavigationLazyView(CategoryView(slug: category.slug)),
                                       tag: category.slug,
                                       selection: $navigationManager.categorySlug) {
                            Text(category.name)
                        }
                        .isDetailLink(false)
                        .id(category.slug)
                    }
                }
                .listStyle(PlainListStyle())
                
                if vm.isLoading {
                    LoadingView()
                }
            }
            .navigationTitle("Ressipy")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
