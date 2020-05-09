//
//  CodeContainerViewController.swift
//  Sourceful Sample
//
//  Created by Alessio Nossa on 09/05/2020.
//  Copyright © 2020 Alessio Nossa. All rights reserved.
//

import UIKit
import Sourceful

class CodeContainerViewController: UIViewController {
    
    var lexer: Lexer = SwiftLexer()
    
    var codeStore: CodeStore!
    
    var syntaxView: SyntaxTextView {
        return self.view as! SyntaxTextView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save)),
//            UIBarButtonItem(title: "Language", style: .plain, target: self, action: #selector(changeLanguage))
        ]
    }
    
    override func loadView() {
        let editorView = SyntaxTextView()
        editorView.text = "Test"
        editorView.delegate = self
        editorView.theme = DefaultSourceCodeTheme()
        
        self.view = editorView
    }

    @objc
    func save() {
        self.codeStore.code = self.syntaxView.text
    }
    
    @objc
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc
//    func changeLanguage() {
//        self.lexer = Python3Lexer()
//
//        self.syntaxView.forceTextUpdate()
//    }
}

extension CodeContainerViewController: SyntaxTextViewDelegate {
    
    func lexerForSource(_ source: String) -> Lexer {
        return self.lexer
    }
    
}
