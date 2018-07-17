//
//  MockLoginService.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 13/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class MockLoginService: ILoginService {

  func login(withName name: String, password: String) -> Observable<AuthenticationToken> {
    let timoutSeconds = RxTimeInterval(1)
    let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    
    if name == "name" && password == "password" {
      let token = AuthenticationToken(token: "MockToken")
      let observable = Observable.just(token).delaySubscription(timoutSeconds, scheduler: concurrentScheduler)
      return observable
    }
    let observable: Observable<AuthenticationToken> = Observable.error(KSGLocalizedError(description: "Can't Login with given UserName and Password"))
      .delaySubscription(timoutSeconds, scheduler: concurrentScheduler)
    return observable
  }
  
}
