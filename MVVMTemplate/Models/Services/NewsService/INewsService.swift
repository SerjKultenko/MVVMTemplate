//
//  INewsService.swift
//  MVVMTemplate
//
//  Created by Sergei Kultenko on 17/07/2018.
//  Copyright © 2018 Sergei Kultenko. All rights reserved.
//

import Foundation
import RxSwift

protocol INewsService {
  func obtainLatestNews() -> Observable<[NewsObject]>
}
