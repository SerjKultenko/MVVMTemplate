//
//  LoginViewModelTests.swift
//  MVVMTemplateTests
//
//  Created by Sergei Kultenko on 17/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import RxSwift
import RxTest
import XCTest
@testable import MVVMTemplate

class LoginViewModelTests: XCTestCase {
  
  class LoginServiceMock: ILoginService {
    func login(withName name: String, password: String) -> Observable<AuthenticationToken> {
      if name == "name" && password == "password" {
        let token = AuthenticationToken(token: "MockToken")
        let observable = Observable.just(token)
        return observable
      }
      let observable: Observable<AuthenticationToken> = Observable.error(KSGLocalizedError(description: "Can't Login with given UserName and Password"))
      return observable
    }
  }
  
  var viewModel: LoginViewModel?
  var router: MockRouter?
  var appState: StateStorage = StateStorage()
  var disposeBag: DisposeBag?
  
  
  override func setUp() {
    super.setUp()
    
    self.disposeBag = DisposeBag()
    let loginService = LoginServiceMock()
    self.router = MockRouter()
    self.appState = StateStorage()
    self.viewModel = LoginViewModel(withRouter: router!, appState: appState, withLoginService: loginService)
    self.viewModel?.password = ""
    self.viewModel?.userName = ""
  }
  
  override func tearDown() {
    router = nil
    viewModel = nil
    disposeBag = nil

    super.tearDown()
  }
  
  func testCanSignInSignal() {
    // Given
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(Bool.self)
    viewModel?.canSignIn
      .subscribe(observer)
      .disposed(by: disposeBag!)

    // When
    //scheduler.start()
    viewModel?.password = "a"
    viewModel?.password = "aa"
    viewModel?.password = "aaa"
    viewModel?.userName = "n"
    viewModel?.userName = "nn"
    viewModel?.userName = "nnn"
    viewModel?.userName = ""

    // Then
    let correctValues = [
      Recorded.next(0, false), //Initial state
      Recorded.next(0, false),
      Recorded.next(0, false),
      Recorded.next(0, false),
      Recorded.next(0, true),
      Recorded.next(0, true),
      Recorded.next(0, true),
      Recorded.next(0, false),
      ]
    XCTAssertEqual(observer.events, correctValues)
  }
  
  func testSignInActionSucceeded() {
    // Given
    let scheduler = TestScheduler(initialClock: 0)
    self.router?.routeFunctionCalled = self.expectation(description: "Login router routeFunctionCalled")
    let observerHUDSignal = scheduler.createObserver(Bool.self)
    let observerErrorAlertSignal = scheduler.createObserver(String.self)

    viewModel?.showHUDSignal
      .subscribe(observerHUDSignal)
      .disposed(by: disposeBag!)
    
    viewModel?.showErrorAlertSignal
      .subscribe(observerErrorAlertSignal)
      .disposed(by: disposeBag!)
    
    // When
    viewModel?.userName = "name"
    viewModel?.password = "password"
    viewModel?.signInAction()
    
    // Then
    let correctHUDSignalValues = [
      Recorded.next(0, false), //Initial state
      Recorded.next(0, true),
      Recorded.next(0, false),
      ]

    self.waitForExpectations(timeout: kTestExpectationTimeout) { [weak self] (error) in
      guard let safeSelf = self else {
        XCTFail()
        return
      }
      XCTAssert(observerErrorAlertSignal.events.isEmpty)
      XCTAssertEqual(observerHUDSignal.events, correctHUDSignalValues)
      XCTAssertEqual(safeSelf.appState.authenticationToken?.token, "MockToken")
      XCTAssertEqual(safeSelf.appState.userInfo?.userName, "name")
    }
  }

  
  func testSignInActionFailed() {
    // Given
    let scheduler = TestScheduler(initialClock: 0)
    let observerHUDSignal = scheduler.createObserver(Bool.self)
    let observerErrorAlertSignal = scheduler.createObserver(String.self)
    
    viewModel?.showHUDSignal
      .subscribe(observerHUDSignal)
      .disposed(by: disposeBag!)
    
    viewModel?.showErrorAlertSignal
      .subscribe(observerErrorAlertSignal)
      .disposed(by: disposeBag!)
    
    // When
    viewModel?.userName = "name"
    viewModel?.password = "wrong-password"
    viewModel?.signInAction()
    
    // Then
    let correctHUDSignalValues = [
      Recorded.next(0, false), //Initial state
      Recorded.next(0, true),
      Recorded.next(0, false),
      ]

    let correctErrorAlertSignalValues = [
      Recorded.next(0, "Sign In Error: Can't Login with given UserName and Password"),
      ]

    print("observerHUDSignal \(observerHUDSignal.events)")
    print("observerErrorAlertSignal \(observerErrorAlertSignal.events)")
    XCTAssertEqual(observerErrorAlertSignal.events, correctErrorAlertSignalValues)
    XCTAssertEqual(observerHUDSignal.events, correctHUDSignalValues)
    XCTAssertEqual(self.appState.authenticationToken?.token, nil)
    XCTAssertEqual(self.appState.userInfo?.userName, nil)
  }
}
