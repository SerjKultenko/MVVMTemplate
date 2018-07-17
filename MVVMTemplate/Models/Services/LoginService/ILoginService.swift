//
//  ILoginService.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 13/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

protocol ILoginService {
  func login(withName name: String, password: String) -> Observable<AuthenticationToken>
}
