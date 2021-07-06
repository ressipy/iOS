//
//  CategoryListView.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject var vm = CategoryListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(vm.categories) { category in
                        NavigationLink(
                            destination: CategoryView(slug: category.slug!),
                            label: {
                                Text(category.name!)
                            })
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
