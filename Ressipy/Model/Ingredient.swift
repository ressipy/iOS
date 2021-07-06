//
//  Ingredient.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation

public class Ingredient: NSObject, NSCoding, Decodable {
    let amount: String
    let name: String
    
    required public init?(coder: NSCoder) {
        amount = coder.decodeObject(forKey: "amount") as! String
        name = coder.decodeObject(forKey: "name") as! String
    }
    
    init(amount: String, name: String) {
        self.amount = amount
        self.name = name
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(amount, forKey: "amount")
        coder.encode(name, forKey: "name")
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.amount == rhs.amount && lhs.name == rhs.name
    }
}
