//
//  Lexer.swift
//  Lexer
//
//  Created by Anastasia on 2/24/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

struct Token {
    
    let type: TokenType
    let value: String
    let line: Int
    let column: Int
}

class Lexer {
    
    let code = "Put lemon juice into the mixing bowl."
    
    let input: String
    let position: Int
    var lineIndex: Int
    var columnIndex: Int
    
    init(input: String) {
        self.input = code
        self.position = 0
        self.lineIndex = 0
        self.columnIndex = 0
    }
    
    func allTokens() -> [Token] {
        var token = try! nextToken()
        var tokens: [Token] = []
        
        while token.type != .EOF {
            tokens.append(token)
            token = try! nextToken()
        }
        tokens.forEach { print($0) }
        return tokens
    }
    
    lazy var lines: [String] = {
        var lines: [String] = []
        
        if let path = Bundle.main.path(forResource: "Program", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                lines = data.components(separatedBy: .newlines)
                print(lines)
            } catch {
                print(error)
            }
        }
        return lines
    }()
    
    lazy var methodHeaderIndex: Int = {
        for (index, line) in lines.enumerated() {
            if line == TokenType.methodHeader.rawValue {
                return index
            }
        }
        return -1
    }()

    
    func nextToken() throws -> Token {
        if lineIndex == lines.count {
            return Token(type: .EOF, value: "", line: lineIndex, column: columnIndex)
        }
        
        guard methodHeaderIndex != -1 else { throw LexicError.noMethod }
        
        let line = lines[lineIndex]
        
        switch lineIndex {
        case 0:
            return try titleToken(line: line)
        case 2:
            return try ingredientsHeaderToken(line: line)
        case 3 ..< methodHeaderIndex - 1:
            return try ingredientToken(line: line)
        case methodHeaderIndex:
            return try methodHeaderToken(line: line)
        case methodHeaderIndex + 1 ..< lines.count - 1:
            return try actionToken(line: line)
        default:
            if line.isEmpty {
                lineIndex += 1
                return Token(type: .emptyLine, value: "\n", line: lineIndex - 1, column: 0)
            }
        }
        
       // return Token(type: .EOF, value: "", line: lineIndex, column: columnIndex)
        throw LexicError.incorrectCharacter
    }
}

private extension Lexer {
    
    func actionToken(line: String) throws -> Token {
        if line.isEmpty {
            throw LexicError.invalidActionCall
            
        }
        
        let croppedLine = line.suffix(from: String.Index(encodedOffset: columnIndex))
        let components = croppedLine.components(separatedBy: " ").filter { !$0.isEmpty }
        var tokenType: TokenType = .EOF
        let component = components[0]
        
        var isCookingWord = false
        
        if component == "." {
            isCookingWord = true
            tokenType = .dot
        } else if Int(component) != nil {
            isCookingWord = true
            tokenType = .number
        } else {
            for keyword in reservedForCooking {
                if component == keyword.rawValue {
                    isCookingWord = true
                    tokenType = keyword
                    break
                }
            }
        }
        
        if !isCookingWord {
            if isWord(word: component) {
                tokenType = .ingridientName
            } else {
                throw LexicError.invalidActionCall
            }
        }
        
        let tokenColumn = columnIndex
        columnIndex += components[0].count + 1
        let value = component + (columnIndex >= line.count ? "\n" : "")
        let tok = Token(type: tokenType, value: value, line: lineIndex, column: tokenColumn)
        
        if columnIndex >= line.count {
            lineIndex += 1
            columnIndex = 0
        }
        return tok
    }
    
    func ingredientsHeaderToken(line: String) throws -> Token {
        if line == TokenType.ingredientsHeader.rawValue {
            lineIndex += 1
            return Token(type: .ingredientsHeader, value: line + "\n", line: lineIndex - 1, column: columnIndex)
        }
        throw LexicError.invalidIngredientsHeader
    }
    
    func methodHeaderToken(line: String) throws -> Token {
        if line == TokenType.methodHeader.rawValue {
            lineIndex += 1
            return Token(type: .methodHeader, value: line + "\n", line: lineIndex - 1, column: columnIndex)
        }
        throw LexicError.invalidMethodHeader
    }
    
    func titleToken(line: String) throws -> Token {
        if isTitle(line: line) {
            lineIndex += 1
            return Token(type: .title, value: line + "\n", line: lineIndex - 1, column: columnIndex)
        }
        throw LexicError.invalidTitle
    }
    
    func ingredientToken(line: String) throws -> Token {
        if line.isEmpty { throw LexicError.invalidIngredientDeclaration }
        
        let croppedLine = line.suffix(from: String.Index(encodedOffset: columnIndex))
        let components = croppedLine.components(separatedBy: " ").filter { !$0.isEmpty }
        let tokenType: TokenType
        let component = components[0]
        
        if Int(component) != nil {
            tokenType = .number
        } else if component == TokenType.mililiters.rawValue {
            tokenType = .mililiters
        } else if component == TokenType.grams.rawValue {
            tokenType = .grams
        } else if isWord(word: component) {
            tokenType = .ingridientName
        } else {
            throw LexicError.invalidIngredientDeclaration
        }
        let tokenColumn = columnIndex
        columnIndex += components[0].count + 1
        let value = component + (columnIndex >= line.count ? "\n" : "")
        let tok = Token(type: tokenType, value: value, line: lineIndex, column: tokenColumn)
        
        if columnIndex >= line.count {
            lineIndex += 1
            columnIndex = 0
        }
        return tok
    }
    
    func isTitle(line: String) -> Bool {
        if line.isEmpty { return false }
        let isTitle = isLetter(char: String(line.first!)) && line.last == "."
        if !isTitle { return false }
        
        let croppedTitle = line.dropFirst().dropLast()
        
        for char in croppedTitle {
            let c = String(char)
            if !(isLetter(char: c) || isDigit(char: c) || isSpace(char: c)) {
                return false
            }
        }
        
        return true
    }
    
    func isWord(word: String) -> Bool {
        for char in word {
            let c = String(char)
            if !isLetter(char: c) {
                return false
            }
        }
        return true
    }
    
}

enum LexicError: Error {
    
    case incorrectCharacter
    case invalidTitle
    case invalidIngredientsHeader
    case invalidMethodHeader
    case invalidIngredientDeclaration
    case invalidActionCall
    case noMethod
}
