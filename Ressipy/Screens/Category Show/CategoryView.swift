//
//  CategoryView.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

struct CategoryView: View {
    let slug: String
    @StateObject var vm = CategoryViewModel()
    
    var body: some View {
        ZStack {
            List {
                ForEach(vm.category?.recipes ?? []) { recipe in
                    NavigationLink(destination: RecipeView(vm: RecipeViewModel(slug: recipe.slug))) {
                        Text(recipe.name)
                    }
                    .id(recipe.id)
                }
            }
            .listStyle(PlainListStyle())
            
            if vm.isLoading {
                LoadingView()
            }
        }
        .navigationTitle(vm.category?.name ?? "")
        .onAppear {
            vm.getCategory(slug: slug)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryView(slug: "appetizers")
        }
    }
}
