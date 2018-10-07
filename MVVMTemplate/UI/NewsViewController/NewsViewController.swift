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

  private let kNewsCellReuseIdentifier = "kNewsCellReuseIdentifier"

  // MARK: - View Controller Lifecycle
  override func loadView() {
    view = Bundle.main.loadNibNamed(self.classString(), owner: self, options: nil)?[0] as? UIView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if viewModel != nil {
      bindSignalProcessing(forBaseViewModel: viewModel!)
    }
    reactiveBindings()

    let selector = #selector(NewsViewController.logoutAction)
    let item = UIBarButtonItem(image: UIImage(named: "icon-exit"), style: .plain, target: self, action: selector)
    navigationItem.rightBarButtonItem = item
    navigationItem.title = "News"
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
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
  
  @IBAction func logoutAction(_ sender: UIBarButtonItem) {
    viewModel?.logoutAction()
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
