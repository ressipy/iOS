//
//  CategoryRecipe.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation

struct CategoryRecipe: Decodable {
    let name: String
    let slug: String
}

extension CategoryRecipe: Identifiable {
    var id: String { return slug }
}
