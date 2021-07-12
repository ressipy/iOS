//
//  Category.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation
import CoreData

struct Category: Decodable {
    let name: String
    let recipes: [Recipe]?
    let slug: String
}

extension Category: Identifiable {
    var id: String { return slug }
}
