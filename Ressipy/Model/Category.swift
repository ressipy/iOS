//
//  Category.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation

struct Category: Decodable {
    let name: String
    let recipes: [CategoryRecipe]?
    let slug: String
}

extension Category: Identifiable {
    var id: String { return slug }
}
