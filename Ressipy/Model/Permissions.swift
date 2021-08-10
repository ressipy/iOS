//
//  Permission.swift
//  Permission
//
//  Created by Dennis Beatty on 8/9/21.
//

import Foundation

struct Permissions: Codable {
    var createCategory = false
    var createRecipe = false
    var deleteCategory = false
    var deleteRecipe = false
    var updateCategory = false
    var updateRecipe = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let permissionSet = try container.decode(Set<String>.self)
        
        createCategory = permissionSet.contains("createCategory")
        createRecipe = permissionSet.contains("createRecipe")
        deleteCategory = permissionSet.contains("deleteCategory")
        deleteRecipe = permissionSet.contains("deleteRecipe")
        updateCategory = permissionSet.contains("updateCategory")
        updateRecipe = permissionSet.contains("updateRecipe")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        var permissions = [String]()
        
        let mirror = Mirror(reflecting: self)
        for (key, value) in mirror.children  {
            if value as! Bool { permissions.append(key!) }
        }
        
        try container.encode(permissions)
    }
}
