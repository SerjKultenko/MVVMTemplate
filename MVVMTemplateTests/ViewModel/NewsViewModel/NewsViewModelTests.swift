//
//  NewsViewModelTests.swift
//  MVVMTemplateTests
//
//  Created by Sergei Kultenko on 18/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import RxSwift
import RxTest
import XCTest
@testable import MVVMTemplate

class NewsViewModelTests: XCTestCase {
  
  static let kTestNewsCount = 50
  
  class NewsServiceMock: INewsService {
    var workProperly = true
    private var latestNews: [NewsObject] {
      var newsArray = [NewsObject]()
      for index in 1...kTestNewsCount {
        let newTitle = "Title #\(index)"
        let newNewsText = "News #\(index)"
        newsArray.append(NewsObject(title: newTitle, newsText: newNewsText))
      }
      return newsArray
    }
    
    func obtainLatestNews() -> Observable<[NewsObject]> {
      if workProperly {
        let observable = Observable.just(latestNews)
        return observable
      }
      // Generate Error
      let observable: Observable<[NewsObject]> = Observable.error(KSGLocalizedError(description: "Can't obtain latest news"))
      return observable
    }
  }

  var viewModel: NewsViewModel?
  var mainRouter: MockRouter?
  var newsService: NewsServiceMock?
  var disposeBag: DisposeBag?
  
  override func setUp() {
    super.setUp()
    
    self.disposeBag = DisposeBag()
    self.newsService = NewsServiceMock()
    self.mainRouter = MockRouter()
    self.viewModel = NewsViewModel(withRouter: mainRouter!, withNewsService: newsService!)
  }
  
  override func tearDown() {
    mainRouter = nil
    newsService = nil
    viewModel = nil
    disposeBag = nil

    super.tearDown()
  }

  func testInitialState() {
    // Given
    
    // When
    
    // Then
    XCTAssertEqual(viewModel?.newsCount, 0)
    XCTAssertNil(viewModel?.getNews(atIndex: 0))
  }

  func testNewsFetchingSucceeded() {
    // Given
    let scheduler = TestScheduler(initialClock: 0)
    let observerHUDSignal = scheduler.createObserver(Bool.self)
    let observerErrorAlertSignal = scheduler.createObserver(String.self)
    let observerReloadDataSignal = scheduler.createObserver(Bool.self)

    viewModel?.showHUDSignal
      .subscribe(observerHUDSignal)
      .disposed(by: disposeBag!)
    
    viewModel?.showErrorAlertSignal
      .subscribe(observerErrorAlertSignal)
      .disposed(by: disposeBag!)
    
    viewModel?.reloadDataSignal
      .subscribe(observerReloadDataSignal)
      .disposed(by: disposeBag!)

    // When
    viewModel?.reloadData()
    
    // Then
    let correctHUDSignalValues = [
      Recorded.next(0, false), //Initial state
      Recorded.next(0, true),
      Recorded.next(0, false),
      ]
    let correctreloadDataSignalValues = [
      Recorded.next(0, false), //Initial state
      Recorded.next(0, true),
      ]

    XCTAssert(observerErrorAlertSignal.events.isEmpty)
    XCTAssertEqual(observerHUDSignal.events, correctHUDSignalValues)
    XCTAssertEqual(observerReloadDataSignal.events, correctreloadDataSignalValues)
    XCTAssertEqual(viewModel?.newsCount, 50)
    
    XCTAssertEqual(viewModel?.getNews(atIndex: 0)?.title, "Title #1")
    XCTAssertEqual(viewModel?.getNews(atIndex: 0)?.newsText, "News #1")

    XCTAssertEqual(viewModel?.getNews(atIndex: 49)?.title, "Title #50")
    XCTAssertEqual(viewModel?.getNews(atIndex: 49)?.newsText, "News #50")
  }
  
  
  func testNewsFetchingFailed() {
    // Given
    let scheduler = TestScheduler(initialClock: 0)
    let observerHUDSignal = scheduler.createObserver(Bool.self)
    let observerErrorAlertSignal = scheduler.createObserver(String.self)
    let observerReloadDataSignal = scheduler.createObserver(Bool.self)
    
    // Break down the newsService
    self.newsService?.workProperly = false
    
    viewModel?.showHUDSignal
      .subscribe(observerHUDSignal)
      .disposed(by: disposeBag!)
    
    viewModel?.showErrorAlertSignal
      .subscribe(observerErrorAlertSignal)
      .disposed(by: disposeBag!)
    
    viewModel?.reloadDataSignal
      .subscribe(observerReloadDataSignal)
      .disposed(by: disposeBag!)
    
    // When
    viewModel?.reloadData()
    
    // Then
    let correctHUDSignalValues = [
      Recorded.next(0, false), //Initial state
      Recorded.next(0, true),
      Recorded.next(0, false),
      ]
    let correctReloadDataSignalValues = [
      Recorded.next(0, false), //Initial state
      Recorded.next(0, true),
      ]
    let correctErrorAlertSignalValues = [
      Recorded.next(0, "News Updating Error: Can't obtain latest news"),
      ]
    
    XCTAssertEqual(observerHUDSignal.events, correctHUDSignalValues)
    XCTAssertEqual(observerReloadDataSignal.events, correctReloadDataSignalValues)
    
    XCTAssertEqual(observerErrorAlertSignal.events, correctErrorAlertSignalValues)

    XCTAssertEqual(viewModel?.newsCount, 0)
  }
}
