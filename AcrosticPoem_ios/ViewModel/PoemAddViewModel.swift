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
    private let poemAddResultRelay = BehaviorRelay<Int?>(value: nil)
  
    var errorMessage : Observable<String> {
        return errorMessageRelay
            .compactMap { $0 }
    }
    var todayTitleSuccess : Observable<String> {
        return todayTitleResultRelay
            .compactMap { $0 }
    }
    var poemAddSuccess : Observable<Int> {
        return poemAddResultRelay
            .filter { $0 == 200 }
            .map { $0! }
    }
    
    var networkService : NetworkService
    
    init() {
        networkService = NetworkService()
    }
    
    func requestTodayTitle(wordCount : Int) {
        networkService.requestTodayTitle(wordCount: wordCount, completion: {
            response in
            switch response {
            case .success(let todayTitle):
                self.todayTitleResultRelay.accept(todayTitle)
            case .failure(_):
                self.errorMessageRelay.accept("오늘의 주제를 불러오는데 실패하였습니다.")
            }
        })
    }
    
    func requestPoemAdd(image : String, word : [Word]) {
        networkService.requestPoemAdd(reqModel: PoemAddReqModel(token: Constant.shared.token, image: image, word: word, wordCount: word.count), completion: {
            response in
            switch response {
            case .success(let code):
                self.poemAddResultRelay.accept(code)
            case .failure(_):
                self.errorMessageRelay.accept("시를 등록하는데 실패하였습니다.")
            }
        })
    }
    
}
