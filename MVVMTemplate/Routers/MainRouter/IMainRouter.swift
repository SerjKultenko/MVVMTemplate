//
//  IMainRouter.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 18/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit

protocol IMainRouter {
  var appState: StateStorage { get }
  
  func getLoginViewController() -> UIViewController
  func switchToMainScreen()

}
