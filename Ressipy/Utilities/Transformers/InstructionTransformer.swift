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
        guard let instructions = value as? [Instruction] else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: instructions, requiringSecureCoding: false)
        } catch {
            print("Failed to encode instruction list - \(error)")
            return nil
        }
    }
    
    // Convert data to an Instruction for use in the application
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Instruction]
        } catch {
            print("Failed to decode instruction list - \(error)")
            return nil
        }
    }
}
