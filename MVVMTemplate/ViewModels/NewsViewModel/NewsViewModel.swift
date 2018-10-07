//
//  NewsViewModel.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 17/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

class NewsViewModel: BaseViewModel {
  
  // MARK: - Private Vars
  private var newsService: INewsService
  
  private var news: [NewsObject] = [] {
    didSet {
      reloadDataSignal.onNext(true)
    }
  }
  
  // MARK: - Public Vars
  var reloadDataSignal = BehaviorSubject<Bool>(value: false)
  var newsCount: Int {
    get {
      return news.count
    }
  }
  func getNews(atIndex index: Int) -> NewsObject? {
    guard index >= 0, news.count > index else { return nil }
    return news[index]
  }
  
  
  // MARK: - Actions
  func reloadData() {
    let observable = newsService.obtainLatestNews()
    
    showHUDSignal.onNext(true)
    observable
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] event in
        guard let strongSelf = self else { return }
        
        switch event {
        case let .next(latestNews):
          strongSelf.news = latestNews
          
          strongSelf.showHUDSignal.onNext(false)
        case let .error(error):
          strongSelf.news = []
          strongSelf.showHUDSignal.onNext(false)
          strongSelf.showErrorAlertSignal.onNext("News Updating Error: " + error.localizedDescription)
        default:
          break
        }
      }.disposed(by: disposeBag)
  }
  
  func logoutAction() {
    router.route(with: NewsRouter.RouteType.gotoLoginScreen)
  }
  
  // MARK: - Initialization
  init(withRouter router: IRouter, withNewsService newsService: INewsService) {
    self.newsService = newsService
    super.init(with: router)
  }
}
