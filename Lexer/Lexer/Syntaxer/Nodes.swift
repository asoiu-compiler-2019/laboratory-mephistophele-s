//
//  Nodes.swift
//  Lexer
//
//  Created by Anastasia on 3/13/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

enum NodeType: String {
    
    case program
    case title
    case emptyLine
    
    case ingredients
    case ingredientsDeclarations
    case ingredientDeclaration
    case ingredientsHeader
    case measure
    case ingridientName
    case number
    
    case cookingMethod
    case methodHeader
    case actionsList
    case action
    
    case command
    case ingredient
    case dish
}
