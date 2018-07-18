//
//  LoginViewModel.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 13/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel: BaseViewModel {
  
  // MARK: - Vars
  private var loginService: ILoginService
  
  var userName: String = "" {
    didSet {
      canSignIn.onNext(fieldsAreValid())
    }
  }
  
  var password: String = "" {
    didSet {
      canSignIn.onNext(fieldsAreValid())
    }
  }
  
  var canSignIn = BehaviorSubject<Bool>(value: false)

  
  // MARK: - Utilities
  private func fieldsAreValid() -> Bool {
    return !userName.isEmpty && !password.isEmpty
  }

  
  // MARK: - Actions
  func signInAction() {
    guard fieldsAreValid() else { return }
    let observable = loginService.login(withName: userName, password: password)
    
    showHUDSignal.onNext(true)
    observable
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] event in
        guard let strongSelf = self else { return }
        
        switch event {
        case let .next(authenticationToken):
          strongSelf.router.appState.authenticationToken = authenticationToken
          strongSelf.router.appState.userInfo = UserInfo(userName: strongSelf.userName)
          
          strongSelf.showHUDSignal.onNext(false)
          strongSelf.router.switchToMainScreen()
        case let .error(error):
          strongSelf.router.appState.authenticationToken = nil
          strongSelf.router.appState.userInfo = nil
          
          strongSelf.showHUDSignal.onNext(false)
          strongSelf.showErrorAlertSignal.onNext("Sign Up Error: " + error.localizedDescription)
        default:
          break
        }
      }.disposed(by: disposeBag)
  }

  // MARK: - Initialization
  init(withRouter router: IMainRouter, withLoginService loginService: ILoginService) {
    self.loginService = loginService
    super.init(with: router)
    
    #if DEBUG
    userName = "name"
    password = "password"
    canSignIn.onNext(fieldsAreValid())
    #endif
  }
}
