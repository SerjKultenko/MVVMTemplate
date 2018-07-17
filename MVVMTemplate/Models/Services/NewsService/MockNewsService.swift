//
//  MockNewsService.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 17/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class MockNewsService: INewsService {
  private let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  
  private var latestNews: [NewsObject] {
    var newsArray = [NewsObject]()
    for index in 1...50 {
      let newTitle = "Title #\(index)"
      let newNewsText = "News #\(index) " + loremIpsum
      newsArray.append(NewsObject(title: newTitle, newsText: newNewsText))
    }
    return newsArray
  }
  
  func obtainLatestNews() -> Observable<[NewsObject]> {
    let timoutSeconds = RxTimeInterval(1)
    let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    
    let observable = Observable.just(latestNews).delaySubscription(timoutSeconds, scheduler: concurrentScheduler)
    return observable
  }
}
