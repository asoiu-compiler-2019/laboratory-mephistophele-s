//
//  Token.swift
//  Lexer
//
//  Created by Anastasia on 2/24/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

enum TokenType: String, CaseIterable {
    
    case dot
    case space
    
    case title
    case emptyLine
    case newLine
    case number
    case ingridientName
    case ingredientsHeader = "Ingredients."
    case methodHeader = "Method."
    
    case grams = "g"
    case mililiters = "ml"
    
    case the = "the"
    case mixing = "mixing"
    case baking = "baking"
    case bowl = "bowl"
    case dish = "dish"
    
    case put = "Put"
    case get = "Get"
    case add = "Add"
    case remove = "Remove"
    case combine = "Combine"
    case devide = "Devide"
    case liquefy = "Liquefy"
    case mix = "Mix"
    case clean = "Clean"
    case serve = "Serve"
    case pour = "Pour"
    
    case into = "into"
    case from = "from"
    case to = "to"
    case well = "well"
    case contents = "contents"
    case of = "of"
    
    case EOF
}

let measures = [TokenType.grams, TokenType.mililiters]
//let containers = [TokenType.bowl, TokenType.dish]
let commands: [TokenType] = [.put, .get, .add, .remove, .combine, .devide, .liquefy, .mix, .clean, .serve, .pour]
let helpers = [TokenType.into, TokenType.from, TokenType.to, TokenType.well, TokenType.of]

let helpersForCommands: [TokenType: TokenType] = [
    .put: .into,
    .get: .from,
    .add: .to,
    .devide: .into,
    .mix: .well]

//let reserved = headers + measures + containers + commands + helpers

let reservedForCooking: [TokenType] = [.put, .get, .add, .remove, .combine, .devide, .liquefy, .mix, .clean, .serve, .into, .from, .to, .well, .of, .contents, .mixing, .baking, .the, .bowl, .dish, .pour]

func isLetter(char: String) -> Bool {
    return char ~= "[a-zA-Z]"
}

func isDigit(char: String) -> Bool {
    return char ~= "[0-9]"
}

func isNewLine(char: String) -> Bool {
    return char ~= "\n"
}

func isSpace(char: String) -> Bool {
    return char ~= " "
}

func isDot(char: String) -> Bool {
    return char ~= "."
}

//func isReserved(text: String) -> Bool {
//    return reserved.map { $0.rawValue }.contains(text)
//}
