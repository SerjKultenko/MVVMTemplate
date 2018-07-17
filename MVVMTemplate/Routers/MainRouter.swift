//
//  MainRouter.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 16/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import UIKit

struct MainRouter {
  // MARK: - Vars
  let appState: StateStorage
  
  // MARK: - Initializers
  init(withStateStorage stateStorage: StateStorage) {
    appState = stateStorage
  }
  
  // MARK: - Functions
  public func getLoginViewController() -> UIViewController {
    let vc = LoginViewController()
    let loginService = MockLoginService()
    let viewModel = LoginViewModel(withRouter: self, withLoginService: loginService)
    vc.viewModel = viewModel
    return vc
  }

  public func switchToMainScreen() {
    guard let appdelegate = UIApplication.shared.delegate as? AppDelegate, let window = appdelegate.window else {
      return
    }
    
    let vc = NewsViewController()
    let newsService = MockNewsService()
    let viewModel = NewsViewModel(withRouter: self, withNewsService: newsService)
    vc.viewModel = viewModel
    
    UIView.transition(with: window, duration: 0.35, options: .transitionCrossDissolve, animations: {
      window.rootViewController = UINavigationController(rootViewController: vc)
    }, completion: nil)
  }
}
