//
//  Ingredient.swift
//  Lexer
//
//  Created by Anastasia on 3/27/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

enum Solidness {
    
    case liquid, solid
}

class Ingredient {
    
    let name: String
    var state: Solidness

    private var numValue: Int
    
    var value: Any {
        return state == .liquid ? (name.first == "s" ? " " : name.first as Any) : numValue
    }
    
    init(state: Solidness, name: String, numValue: Int) {
        self.state = state
        self.name = name
        self.numValue = numValue
    }
    
    func liquefy() {
        self.state = .liquid
    }
}
