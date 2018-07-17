//
//  LoginViewController.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 13/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController, ISignalsProcessingViewController {
  // MARK: - Vars
  var viewModel: LoginViewModel?
  internal let disposeBag = DisposeBag()

  // MARK: - IB Outlets
  @IBOutlet weak var userNameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var signInButton: UIButton!

  
  // MARK: - View Controller Lifecycle
  
  override func loadView() {
    view = Bundle.main.loadNibNamed(self.classString(), owner: self, options: nil)?[0] as? UIView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureControlls()
    if viewModel != nil {
      bindSignalProcessing(forBaseViewModel: viewModel!)
    }
    reactiveBindings()
  }

  
  // MARK: - Utility Functions
  
  private func configureControlls() {
    userNameField.text = viewModel?.userName ?? ""
    passwordField.text = viewModel?.password ?? ""
  }
  
  private func reactiveBindings() {
    viewModel?.canSignIn
      .observeOn(MainScheduler.instance)
      .subscribe({[weak self] (event) in
      guard let strongSelf = self else {return}
      switch event {
      case let .next(canSignInValue):
        strongSelf.signInButton.isEnabled = canSignInValue
      default:
        break
      }
    }).disposed(by: disposeBag)
  }

  
  // MARK: - Events Handlers
  
  @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    switch sender {
    case userNameField:
      viewModel?.userName = userNameField.text ?? ""
    case passwordField:
      viewModel?.password = passwordField.text ?? ""
    default:
      break
    }
  }
  
  @IBAction func signInAction(_ sender: UIButton) {
    viewModel?.signInAction()
  }
  
}
