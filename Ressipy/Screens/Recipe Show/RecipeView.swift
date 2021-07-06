//
//  RecipeView.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var vm: RecipeViewModel
    
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
                
                if vm.isLoading {
                    LoadingView()
                }
            }
        }
        .onAppear {
            vm.getRecipe()
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeView(vm: RecipeViewModel(slug: "spaghetti"))
        }
    }
}
