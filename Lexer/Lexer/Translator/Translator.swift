//
//  Translator.swift
//  Lexer
//
//  Created by Anastasia on 3/17/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class Translator {
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    var stack = Stack()
    var variables: [String: Ingredient] = [:]
    
    func run() {
        root.printTree()
        getVars()
        performCommands()
    }
    
    private func performCommands() {
        let commands = root.children[4].children[1]
        
        for command in commands.children {
            switch command.value?.value {
            case "Put":
                try! put(command: command)
            case "Liquefy":
                try! liquefy(command: command)
            case "Serve":
                serve(command: command)
            default:
                break
            }
        }
        
    }
    
    private func put(command: Node) throws {
        let name = (command.children[0].value?.value)!
        guard let ing = variables[name] else {
            throw SemanticError.noSuchIngredient
        }
        stack.push(ing)
    }
    
    private func liquefy(command: Node) throws {
        variables.values.forEach { $0.liquefy() }
    }
    
    private func serve(command: Node) {
        print(stack)
    }
    
    private func getVars() {
        let ingredients = root.children[2].children[1]
        ingredients.printTree()
        
        for ing in ingredients.children {
            let number = (ing.children[0].value?.value)!
            let num = Int(number)!
            let measure = ing.children[1].value?.value
            let state = (measure == "g" ? Solidness.solid : Solidness.liquid)
            let name = String((ing.children[2].value?.value)!.dropLast())
            
            let ingredient = Ingredient(state: state, name: name, numValue: num)
            variables[name] = ingredient
        }
        
    }
}

enum SemanticError: Error {
    
    case noSuchIngredient
}
