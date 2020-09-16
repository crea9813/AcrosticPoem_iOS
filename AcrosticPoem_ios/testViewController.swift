//
//  testViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/09/14.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit
import RxSwift

class testViewController : UIViewController {
    
    let ns = NetworkService()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ns.generationToken()
            .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { token in
                print(token)
        },
            onError: { error in
                switch error {
                case ApiError.unAuthorized:
                    print("unAuthorized")
                case ApiError.internalServerError:
                    print("Server Error")
                default:
                    print("Unknown Error")
                }
        })
        .disposed(by: disposeBag)
        
       
    }
}
