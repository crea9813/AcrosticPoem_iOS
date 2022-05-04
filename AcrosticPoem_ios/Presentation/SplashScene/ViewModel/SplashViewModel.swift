//
//  SplashViewModel.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/05/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class SplashViewModel : ViewModelType {
    
    struct Input {
        let viewWillAppear : Observable<Void>
    }
    
    struct Output {
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
