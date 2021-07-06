//
//  Ingredient.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation

struct Ingredient: Decodable, Hashable {
    let amount: String
    let name: String
}
