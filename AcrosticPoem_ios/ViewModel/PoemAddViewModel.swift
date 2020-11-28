//
//  PoemAddViewModel.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/28.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import RxSwift
import RxRelay

class PoemAddViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    private let todayTitleResultRelay = BehaviorRelay<String?>(value: nil)
  
    var errorMessage : Observable<String> {
        return errorMessageRelay
            .compactMap { $0 }
    }
    var todayTitleSuccess : Observable<String> {
        return todayTitleResultRelay
            .compactMap { $0 }
    }
    
    func requestTodayTitle(wordCount : Int) {
        PoemService.requestTodayTitle(wordCount: wordCount, completion: {
            response in
            switch response {
            case .success(let todayTitle):
                self.todayTitleResultRelay.accept(todayTitle)
            case .failure(_):
                self.errorMessageRelay.accept("오늘의 주제를 불러오는데 실패하였습니다.")
            }
        })
    }
    
}
