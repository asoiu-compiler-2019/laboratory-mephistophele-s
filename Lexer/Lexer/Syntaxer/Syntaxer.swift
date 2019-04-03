//
//  Syntaxer.swift
//  Lexer
//
//  Created by Anastasia on 3/13/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

final class Syntaxer {
    
    private let tokens: [Token]
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    lazy var methodHeaderIndex: Int = {
        for (index, token) in tokens.enumerated() {
            if token.type == .methodHeader {
                return index
            }
        }
        return -1
    }()
    
    func tree() throws -> Node {
        let program = Node(type: .program)
        
        program.add(child: try fetchTitle(tokens[0]))
        program.add(child: try fetchEmptyLine(tokens[1]))
        
        let ingrs = Array(tokens[2 ..< (methodHeaderIndex - 1)])
        let ingredients = try fetchIngredients(tokens: ingrs)
        program.add(child: ingredients)
        
        program.add(child: try fetchEmptyLine(tokens[methodHeaderIndex - 1]))
        
        let methodLines = Array(tokens[methodHeaderIndex ..< tokens.count])
        let method = try fetchMethod(tokens: methodLines)
        program.add(child: method)
        return program
    }
    
    private func fetchMethod(tokens: [Token]) throws -> Node {
        let methodNode = Node(type: .cookingMethod)
        let header = tokens[0]
        
        if header.type == .methodHeader {
            methodNode.add(child: Node(type: .methodHeader, value: header))
        } else {
            throw SyntaxError.noHeader
        }
        
        let actionsNode = Node(type: .actionsList)
        
        let actions = splitMethod(tokens: Array(tokens.dropFirst()))
        
        for action in actions {
            let command = action[0]
            if !commands.contains(command.type)  {
                throw SyntaxError.noCommand
            }
            let commandNode = Node(type: .command, value: command)
            
            if action[1].type == .ingridientName {
                let nameNode = Node(type: .ingridientName, value: action[1])
                commandNode.add(child: nameNode)
                
                if action.count < 6 {
                    throw SyntaxError.invalidCommand
                }
                if action[3].type == .the && ((action[4].type == .mixing && action[5].type == .bowl)
                    || (action[4].type == .baking && action[5].type == .dish)) {
                    let dishNode = Node(type: .dish, value: action[5])
                    commandNode.add(child: dishNode)
                } else {
                    throw SyntaxError.invalidCommand
                }
            } else if action[1].type == .number {
                if action.count > 2 {
                    throw SyntaxError.invalidCommand
                }
                let numberNode = Node(type: .number, value: action[1])
                commandNode.add(child: numberNode)
            } else if action[1].type == .contents {
                if action.count < 6 {
                    throw SyntaxError.invalidCommand
                }
                if action[2].type == .of
                    && action[3].type == .the
                    && ((action[4].type == .mixing && action[5].type == .bowl)
                        || (action[4].type == .baking && action[5].type == .dish)) {
                    let dishNode = Node(type: .dish, value: action[5])
                    commandNode.add(child: dishNode)
                } else {
                    throw SyntaxError.invalidCommand
                }
                
                if action.count > 6 {
                    if action.count != 10 {
                        throw SyntaxError.invalidCommand
                    }
                    if action[7].type == .the
                        && ((action[8].type == .mixing && action[9].type == .bowl)
                            || (action[8].type == .baking && action[9].type == .dish)) {
                        let dishNode = Node(type: .dish, value: action[9])
                        commandNode.add(child: dishNode)
                    }
                }
            }
            
            
            actionsNode.add(child: commandNode)
        }
        methodNode.add(child: actionsNode)
        return methodNode
    }
    
    private func splitMethod(tokens: [Token]) -> [[Token]] {
        var actions: [[Token]] = []
        var currentIndex = 0
        for (index, token) in tokens.enumerated() {
            if index <= currentIndex { continue }
            if commands.contains(token.type) || index == (tokens.count - 1) {
                let action = Array(tokens[currentIndex..<index])
                actions.append(action)
                currentIndex = index
            }
        }
        return actions
    }
    
    private func fetchIngredients(tokens: [Token]) throws -> Node {
        let ingredientsNode = Node(type: .ingredients)
        let header = tokens[0]
        
        if header.type == .ingredientsHeader {
            ingredientsNode.add(child: Node(type: .ingredientsHeader, value: header))
        } else {
            throw SyntaxError.noHeader
        }
        
        let declarationsNode = Node(type: .ingredientsDeclarations)
        
        let declarations = Array(tokens.dropFirst()).chunked(into: 3)
        
        for dec in declarations {
            guard dec.count == 3 else { throw SyntaxError.invalidDeclaration }
            
            let declarationNode = Node(type: .ingredientDeclaration)
            
            let number = dec[0]
            if number.type == .number {
                let numberNode = Node(type: .number, value: number)
                declarationNode.add(child: numberNode)
            } else {
                throw SyntaxError.noNumberForIngredient
            }
            
            let measure = dec[1]
            if measures.contains(measure.type) {
                let measureNode = Node(type: .measure, value: measure)
                declarationNode.add(child: measureNode)
            } else {
                throw SyntaxError.noMeasureStated
            }
            
            let name = dec[2]
            if name.type == .ingridientName {
                let nameNode = Node(type: .ingridientName, value: name)
                declarationNode.add(child: nameNode)
            }
            declarationsNode.add(child: declarationNode)
        }
        
        ingredientsNode.add(child: declarationsNode)
        
        return ingredientsNode
    }
    
    private func fetchEmptyLine(_ token: Token) throws -> Node {
        if token.type == .emptyLine {
            let node = Node(type: .emptyLine, value: token)
            return node
        } else {
            throw SyntaxError.emptyLineNeeded
        }
    }
    
    private func fetchTitle(_ title: Token) throws -> Node {
        if title.type == .title {
            let titleNode = Node(type: .title, value: title)
            return titleNode
        } else {
            throw SyntaxError.noTitle
        }
    }
}



enum SyntaxError: Error {
    
    case noTitle
    case emptyLineNeeded
    case noHeader
    case noNumberForIngredient
    case noMeasureStated
    case invalidDeclaration
    case noCommand
    case invalidCommand
}
