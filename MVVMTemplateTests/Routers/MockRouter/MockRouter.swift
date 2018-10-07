//
//  MockRouter.swift
//  MVVMTemplateTests
//
//  Created by Kultenko Sergey on 07/10/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import XCTest
import UIKit
@testable import MVVMTemplate

class MockRouter: IRouter {
  // MARK: - Expectations
  var presentFunctionCalled: XCTestExpectation?
  var routeFunctionCalled: XCTestExpectation?
  var dismissFunctionCalled: XCTestExpectation?

  
  // MARK: - Vars
  var presentingViewController: UIViewController?
  
  // MARK: - Functions
  func present(on presentingVC: UIViewController?, context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    presentFunctionCalled?.fulfill()

  }
  
  func route(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    routeFunctionCalled?.fulfill()
  }
  
  
  func dismiss(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
    dismissFunctionCalled?.fulfill()
  }
}
