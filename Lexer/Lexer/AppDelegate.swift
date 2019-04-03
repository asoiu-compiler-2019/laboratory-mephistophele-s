//
//  AppDelegate.swift
//  Lexer
//
//  Created by Anastasia on 2/24/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let lexer = Lexer(input: "")
        let tokens = lexer.allTokens()
        
        let syntaxer = Syntaxer(tokens: tokens)
        let node = try! syntaxer.tree()
        
        let translator = Translator(root: node)
        translator.run()
    }
}

