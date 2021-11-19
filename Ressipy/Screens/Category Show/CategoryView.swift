//
//  CategoryView.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var navigationManager = NavigationManager.shared
    @ObservedObject var vm: CategoryViewModel
    
    init(slug: String) {
        print("Initializing category \(slug). Recipe: \(NavigationManager.shared.recipeSlug ?? "none")")
        vm = CategoryViewModel(slug: slug)
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(vm.recipes) { recipe in
                    NavigationLink(destination: NavigationLazyView(RecipeView(slug: recipe.slug)),
                                   tag: recipe.slug,
                                   selection: $navigationManager.recipeSlug) {
                        Text(recipe.name)
                    }
                    .id(recipe.id)
                }
                .onDelete(perform: vm.allowDelete ? vm.deleteRecipes : nil)
            }
            .listStyle(PlainListStyle())
            
            if vm.isLoading {
                LoadingView()
            }
        }
        .navigationTitle(vm.category?.name ?? "")
        .navigationBarItems(trailing: vm.showNewRecipeButton ? AnyView(newRecipeButton) : AnyView(EmptyView()))
        .sheet(isPresented: $vm.showNewRecipeForm) {
            NewRecipeView(category: vm.category!, delegate: vm)
        }
    }
    
    var newRecipeButton: some View {
        Button {
            vm.displayNewRecipeForm()
        } label: {
            Image(systemName: "plus")
                .foregroundColor(.accentColor)
                .frame(width: 20, height: 20)
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
