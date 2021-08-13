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
            RecipeList(recipes: vm.category?.recipes ?? [])
            
            if vm.isLoading {
                LoadingView()
            }
        }
        .navigationTitle(vm.category?.name ?? "")
        .navigationBarItems(trailing: vm.showNewRecipeButton ? AnyView(newRecipeButton) : AnyView(EmptyView()))
        .onAppear {
            vm.getCategory(slug: slug)
        }
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
