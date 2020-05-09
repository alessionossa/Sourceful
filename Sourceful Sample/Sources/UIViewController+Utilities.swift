//
//  UIViewController+Utilities.swift
//  Sourceful Sample
//
//  Created by Alessio Nossa on 09/05/2020.
//  Copyright © 2020 Alessio Nossa. All rights reserved.
//

import Foundation
import SwiftUI

struct ViewControllerHolder {
    weak var value: UIViewController?
    init(_ value: UIViewController?) {
        self.value = value
    }
}

struct RootViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(UIApplication.shared.windows.first?.rootViewController)
    }
}

extension EnvironmentValues {
    var viewController: ViewControllerHolder {
        get {
            return self[RootViewControllerKey.self]
        }
        set {
            self[RootViewControllerKey.self] = newValue
        }
    }
}

extension UIViewController {
    func present<Content: View>(presentationStyle: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, animated: Bool = true, completion: @escaping () -> Void = {}, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = presentationStyle
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, ViewControllerHolder(toPresent))
        )
        if presentationStyle == .overCurrentContext {
            toPresent.view.backgroundColor = .clear
        }
        self.present(toPresent, animated: animated, completion: completion)
    }
}
