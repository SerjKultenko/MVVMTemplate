//
//  NewsViewController.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 17/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import UIKit
import RxSwift

class NewsViewController: UIViewController, ISignalsProcessingViewController {
  // MARK: - Vars
  var viewModel: NewsViewModel?
  internal let disposeBag = DisposeBag()
  
  // MARK: - IB Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - View Controller Lifecycle
  override func loadView() {
    view = Bundle.main.loadNibNamed(self.classString(), owner: self, options: nil)?[0] as? UIView
  }

  private let kNewsCellReuseIdentifier = "kNewsCellReuseIdentifier"
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if viewModel != nil {
      bindSignalProcessing(forBaseViewModel: viewModel!)
    }
    reactiveBindings()

    self.viewModel?.reloadData()
  }


  // MARK: - Utility Functions
  private func reactiveBindings() {
    viewModel?.reloadDataSignal
      .observeOn(MainScheduler.instance)
      .subscribe({[weak self] (event) in
        guard let safeSelf = self else {return}
        switch event {
        case let .next(shouldReloadData):
          if shouldReloadData {
            safeSelf.tableView.reloadData()
          }
        default:
          break
        }
      }).disposed(by: disposeBag)
  }
}

extension NewsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.newsCount ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell:UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: kNewsCellReuseIdentifier)
    if cell == nil {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: kNewsCellReuseIdentifier)
      cell.detailTextLabel?.numberOfLines = 0
      cell.imageView?.image = UIImage(named: "news-image")
    }
    
    if let newsForCell = self.viewModel?.getNews(atIndex: indexPath.row) {
      cell.textLabel?.text = newsForCell.title
      cell.detailTextLabel?.text = newsForCell.newsText
    } else {
      cell.textLabel?.text = ""
      cell.detailTextLabel?.text = ""
    }

    return cell
  }
  
}

extension NewsViewController: UITableViewDelegate {
  
}
