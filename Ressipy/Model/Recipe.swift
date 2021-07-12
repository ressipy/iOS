//
//  Recipe.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import CoreData
import Foundation

struct Recipe: Decodable {
    let author: String?
    let category: Category?
    let ingredients: [Ingredient]?
    let instructions: [Instruction]?
    let name: String
    let slug: String
}

extension Recipe: Identifiable {
    var id: String { return slug }
}
