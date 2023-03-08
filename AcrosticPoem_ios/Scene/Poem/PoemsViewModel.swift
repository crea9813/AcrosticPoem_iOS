//
//  PoemsViewModel.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PoemsViewModel: ViewModelType {
    
    struct Input {
        let didCreatePoemClicked: Driver<Void>
        
        let didLikePoem: Driver<PoemItemViewModel>
    }
    
    struct Output {
//        let poemTitle: Driver<String>
//        
//        let poems: Driver<[PoemItemViewModel]>
//        
//        let createPoem: Driver<Void>
//        
//        let like: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
