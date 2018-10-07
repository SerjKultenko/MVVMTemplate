//
//  LoginRouter.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 23/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit

class LoginRouter: IRouter, IRootRouter {
  
  enum RouteType {
    case showNewsList
  }
  
  var rootVCContext: RootVCContext?
  
  weak var presentingViewController: UIViewController?
  
  func present(on presentingVC: UIViewController?, context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    guard let rootVCContext = context as? RootVCContext  else {
      assertionFailure("Initial context in LoginRouter is not of RootVCContext type")
      return
    }
    self.rootVCContext = rootVCContext
    
    let vc = LoginViewController()
    let loginService = MockLoginService()
    let viewModel = LoginViewModel(withRouter: self, appState: rootVCContext.appState , withLoginService: loginService)
    vc.viewModel = viewModel

    self.presentingViewController = vc
    
    rootVCContext.window.rootViewController = vc
  }
  
  func route(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    guard let routeType = context as? RouteType else {
      assertionFailure("Context in LoginRouter is not RouteType")
      return
    }
//    guard let presentingViewController = presentingViewController else {
//      assertionFailure("presentingViewController was not set")
//      return
//    }
    
    switch routeType {
    case .showNewsList:
      let newsRouter = NewsRouter()
      newsRouter.present(on: nil, context: rootVCContext, animated: true, completion: nil)
      break
    }
  }
  
  func dismiss(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    // Empty
  }
  
}
