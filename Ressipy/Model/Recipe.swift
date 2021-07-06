//
//  Recipe.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation

struct Recipe: Decodable {
    let author: String?
    let category: Category
    let ingredients: [Ingredient]
    let instructions: [Instruction]
    let name: String
    let slug: String
}

extension Recipe: Identifiable {
    var id: String { return slug }
}

struct MockData {
    let recipe = Recipe(
        author: "Cari Beatty",
        category: Category(
            name: "Pasta",
            recipes: nil,
            slug: "pasta"),
        ingredients: [
            Ingredient(amount: "32 oz", name: "tomato sauce**"),
            Ingredient(amount: "2 tsp", name: "oregano"),
            Ingredient(amount: "1 lb", name: "ground beef"),
            Ingredient(amount: "4 oz", name: "sliced fresh mushrooms, optional"),
            Ingredient(amount: "1/2 cup", name: "chopped onion"),
            Ingredient(amount: "1 tsp", name: "salt"),
            Ingredient(amount: "16 oz", name: "spaghetti"),
            Ingredient(amount: "2 cloves", name: "minced garlic"),
            Ingredient(amount: "2 tsp", name: "basil"),
        ],
        instructions: [
            Instruction(text: "Brown ground beef with onion and garlic."),
            Instruction(text: "Drain."),
            Instruction(text: "Add tomato sauce, seasonings, and mushrooms (optional)."),
            Instruction(text: "Bring to boil and reduce heat to simmer."),
            Instruction(text: "In large stockpot, cook spaghetti according to package directions. Drain."),
            Instruction(text: "Combine spaghetti and sauce."),
            Instruction(text: "**14 oz. petite diced tomatoes, 8 oz. tomato sauce, and 6 oz. tomato paste may be substituted for 32 oz. tomato sauce"),
        ],
        name: "Spaghetti",
        slug: "spaghetti"
    )
}
