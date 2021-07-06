//
//  InstructionTransformer.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/6/21.
//

import UIKit

class InstructionTransformer: ValueTransformer {
    // Convert an Instruction to data for storage in our persistence layer
    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? Instruction else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: true)
        } catch {
            return nil
        }
    }
    
    // Convert data to an Instruction for use in the application
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: Instruction.self, from: data)
        } catch {
            return nil
        }
    }
}
