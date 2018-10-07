//
//  NewsRouter.swift
//  MVVMTemplate
//
//  Created by Kultenko Sergey on 07/10/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit

class NewsRouter: IRouter, IRootRouter {
  
  enum RouteType {
    //case addNewContact(StateStorage)
    //case searchContact(StateStorage)
    case gotoLoginScreen
  }
  
  var rootVCContext: RootVCContext?
  
  weak var presentingViewController: UIViewController?
  
  func present(on presentingVC: UIViewController?, context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    guard let rootVCContext = context as? RootVCContext  else {
      assertionFailure("Initial context in DashboardRouter is not of RootVCContext type")
      return
    }
    self.rootVCContext = rootVCContext
    
    let vc = NewsViewController()
    let newsService = MockNewsService()
    let viewModel = NewsViewModel(withRouter: self, withNewsService: newsService)
    vc.viewModel = viewModel
    
    UIView.transition(with: rootVCContext.window, duration: 0.35, options: .transitionCrossDissolve, animations: {
      let navigation = UINavigationController(rootViewController: vc)
      self.presentingViewController = navigation
      rootVCContext.window.rootViewController = navigation
    }, completion: nil)
  }
  
  func route(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    guard let routeType = context as? RouteType else {
      assertionFailure("Context in DashboardRouter is not RouteType")
      return
    }
//    guard let presentingViewController = presentingViewController else {
//      assertionFailure("presentingViewController was not set")
//      return
//    }
    
    switch routeType {
    case .gotoLoginScreen:
      let router = LoginRouter()
      router.present(on: nil, context: self.rootVCContext, animated: true, completion: nil)
      break
    }
  }
  
  func dismiss(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    // Empty
  }
  
}
