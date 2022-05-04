//
//  Reactive+Extension.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/05/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import RxSwift

extension RxSwift.Reactive where Base: UIViewController {
    public var viewWillAppear: Observable<Bool> {
    return methodInvoked(#selector(UIViewController.viewWillAppear))
       .map { $0.first as? Bool ?? false }
  }
}
