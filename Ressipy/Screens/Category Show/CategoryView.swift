//
//  CategoryView.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var vm: CategoryViewModel
    
    init(slug: String) {
        vm = CategoryViewModel(slug: slug)
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(vm.category?.recipes ?? []) { recipe in
                    NavigationLink(destination: RecipeView(slug: recipe.slug)) {
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
