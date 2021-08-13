//
//  RecipeList.swift
//  RecipeList
//
//  Created by Dennis Beatty on 8/12/21.
//

import SwiftUI

struct RecipeList: View {
    let recipes: [Recipe]
    
    var body: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeView(vm: RecipeViewModel(slug: recipe.slug))) {
                    Text(recipe.name)
                }
                .id(recipe.id)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList(recipes: [])
    }
}
