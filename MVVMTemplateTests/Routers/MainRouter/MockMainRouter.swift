//
//  MockMainRouter.swift
//  MVVMTemplateTests
//
//  Created by Sergei Kultenko on 18/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import XCTest
import UIKit
@testable import MVVMTemplate

class MockMainRouter: IMainRouter {
  // MARK: - Expectations
  var getLoginViewControllerCalled: XCTestExpectation?
  var switchToMainScreenCalled: XCTestExpectation?

  
  // MARK: - Vars
  let appState: StateStorage = StateStorage()
  
  // MARK: - Functions
  public func getLoginViewController() -> UIViewController {
    getLoginViewControllerCalled?.fulfill()
    return UIViewController()
  }
  
  public func switchToMainScreen() {
    switchToMainScreenCalled?.fulfill()
  }
}
