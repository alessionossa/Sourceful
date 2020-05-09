//
//  ContentView.swift
//  Sourceful Sample
//
//  Created by Alessio Nossa on 09/05/2020.
//  Copyright © 2020 Alessio Nossa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.viewController) private var viewControllerHolder: ViewControllerHolder
    
    @ObservedObject var store = CodeStore()
    
    var body: some View {
        VStack {
            Button(action: {
                self.viewControllerHolder.value?.present(self.getEditorViewController(), animated: true, completion: {
                    print("Okay")
                })
            }) {
                Text("Show editor")
            }
            Divider()
            Text("Code")
                .font(.title)
            ZStack {
                Color(red: 0.90, green: 0.90, blue: 0.95)
                    .blur(radius: 4)
                Text(store.code ?? "No code... 🤷‍♂️")
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
    
    
    func getEditorViewController() -> UIViewController {
        
        let codeContainerVC = CodeContainerViewController()
        codeContainerVC.codeStore = self.store
        
        let mainVC = UINavigationController(rootViewController: codeContainerVC)
        mainVC.navigationBar.barStyle = .black
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle =  .coverVertical
        
        return mainVC
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
