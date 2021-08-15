//
//  RecipeView.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var vm: RecipeViewModel
    
    init(slug: String) {
        vm = RecipeViewModel(slug: slug)
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    if vm.recipe?.author != nil {
                        Text("by \(vm.recipe!.author!)")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    
                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(vm.recipe?.ingredients ?? [], id: \.hashValue) { ingredient in
                            Text("\(ingredient.amount) \(ingredient.name)")
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Instructions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(vm.enumeratedInstructions, id: \.1) { index, instruction in
                            Text("\(index + 1).  \(instruction.text)")
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .navigationTitle(vm.recipe?.name ?? "")
                .navigationBarItems(trailing: vm.showEditButton ? AnyView(editButton) : AnyView(EmptyView()))
                
                if vm.isLoading {
                    LoadingView()
                }
            }
        }
        .sheet(isPresented: $vm.showEditForm) {
            NewRecipeView(recipe: vm.recipe!, delegate: vm)
        }
    }
    
    var editButton: some View {
        Button {
            vm.displayEditForm()
        } label: {
            Text("Edit")
                .foregroundColor(.accentColor)
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeView(slug: "spaghetti")
        }
    }
}
