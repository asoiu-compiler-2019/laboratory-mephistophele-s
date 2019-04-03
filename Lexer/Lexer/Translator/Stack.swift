//
//  Stack.swift
//  Lexer
//
//  Created by Anastasia on 3/27/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

struct Stack {
    
    private var array: [Ingredient] = []
    
    mutating func push(_ element: Ingredient) {
        array.append(element)
    }
    
    mutating func pop() -> Ingredient? {
        return array.popLast()
    }
    
    func peek() -> Ingredient? {
        return array.last
    }
}

extension Stack: CustomStringConvertible {

    var description: String {
        let topDivider = "---Result---\n"
        let bottomDivider = "\n-----------\n"
        let stackElements = array.map({ ing -> String in

            if let num = ing.value as? Int {
                return String(num)
            }
            
            if let str = ing.value as? Character {
                return String(str)
            }
            
            return ""
        })
            .reversed()
            .joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
}
