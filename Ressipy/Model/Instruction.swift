//
//  Instruction.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import Foundation

public class Instruction: NSObject, NSCoding, Decodable {
    let text: String
    
    required public init?(coder: NSCoder) {
        text = coder.decodeObject(forKey: "text") as! String
    }
    
    init(text: String) {
        self.text = text
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(text, forKey: "text")
    }
    
    static func == (lhs: Instruction, rhs: Instruction) -> Bool {
        lhs.text == rhs.text
    }
}
