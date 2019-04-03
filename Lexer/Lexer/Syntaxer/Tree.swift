//
//  Tree.swift
//  Lexer
//
//  Created by Anastasia on 3/13/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class Node {
    var type: NodeType
    var value: Token?
    var children: [Node] = []
    weak var parent: Node?
    
    init(type: NodeType, value: Token? = nil) {
        self.type = type
        self.value = value
    }
    
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }
}

extension Node: CustomStringConvertible {

    var description: String {

        var text = "\(type)"
        
        if !children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}

extension Node {
    func treeLines(_ nodeIndent: String = "", _ childIndent: String = "") -> [String] {
        var val = ""
        if let v = value {
            val = v.value
        }
        return [ nodeIndent + "\(type)" + " \(val)" ]
            + children.enumerated().map{ ($0 < children.count-1, $1) }
                .flatMap{ $0 ? $1.treeLines("┣╸","┃ ") : $1.treeLines("┗╸","  ") }
                .map{ childIndent + $0 }
    }
    
    func printTree() {
        print(treeLines().joined(separator:"\n"))
    }
}
