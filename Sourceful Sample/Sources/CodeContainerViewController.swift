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
    
    enum Languages: CaseIterable {
        case swift, python3
    }
    
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
            UIBarButtonItem(title: "Language", style: .plain, target: self, action: #selector(showChangeLanguage))
        ]
    }
    
    override func loadView() {
        let editorView = SyntaxTextView()
        editorView.text = codeStore.code ?? "// This is a sample Swift comment"
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
    
    @objc
    func showChangeLanguage(_ sender: UIBarButtonItem) {
        let popover = LanguagePickerView.makePopover(delegate: self)
        
        popover.popoverPresentationController?.barButtonItem = sender
        
        self.present(popover, animated: true, completion: nil)
    }
}

extension CodeContainerViewController: SyntaxTextViewDelegate {
    
    func lexerForSource(_ source: String) -> Lexer {
        return self.lexer
    }
    
}

extension CodeContainerViewController: LanguageSelectorDelegate {
    
    func didSelectLanguage(_ language: Languages) {
        switch language {
        case .swift:
            self.lexer = SwiftLexer()
        case .python3:
            self.lexer = Python3Lexer()
        }
        
        self.syntaxView.forceTextUpdate()
    }
}


protocol LanguageSelectorDelegate {
    func didSelectLanguage(_ language: CodeContainerViewController.Languages)
}

class LanguagePickerView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var languageDelegate: LanguageSelectorDelegate!
    
    var pickerView: UIPickerView {
        return self.view as! UIPickerView
    }
    
    static func makePopover(delegate: LanguageSelectorDelegate) -> UIViewController {
        let pickerVC = self.init()
        pickerVC.languageDelegate = delegate
        
        let mainVC = UINavigationController(rootViewController: pickerVC)
        mainVC.modalPresentationStyle = .popover
        
        return mainVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateLanguage))
    }
    
    override func loadView() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        self.view = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CodeContainerViewController.Languages.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let language = CodeContainerViewController.Languages.allCases[row]
        
        switch language {
        case .swift:
            return "Swift"
        case .python3:
            return "Python 3"
        }
    }
    
    @objc
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func updateLanguage() {
        let rowSelected = self.pickerView.selectedRow(inComponent: 0)
        let languageSelected = CodeContainerViewController.Languages.allCases[rowSelected]
        
        self.languageDelegate.didSelectLanguage(languageSelected)
        self.dismiss(animated: true, completion: nil)
    }
}
