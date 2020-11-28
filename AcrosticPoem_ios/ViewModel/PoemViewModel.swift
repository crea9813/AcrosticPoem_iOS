//
//  PoemViewModel.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/24.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import RxSwift
import RxRelay

class PoemViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    private let poemListResultRelay = BehaviorRelay<PoemListGetResModel?>(value: nil)
    private let poemInfoResultRelay = BehaviorRelay<PoemModel?>(value: nil)
    private let poemUpdateResultRelay = BehaviorRelay<PoemModel?>(value: nil)
    private let todayTitleResultRelay = BehaviorRelay<String?>(value: nil)
    private let poemLikeResultRelay = BehaviorRelay<Int?>(value: nil)
    private let poemReportResultRelay = BehaviorRelay<Int?>(value: nil)
  
    var errorMessage : Observable<String> {
        return errorMessageRelay
            .compactMap { $0 }
    }
    var poemListSuccess : Observable<[String]> {
        return poemListResultRelay
            .compactMap { $0 }
            .filter { $0.poemId != nil }
            .map { $0.poemId! }
    }
    var poemUpdateSuccess : Observable<PoemModel> {
        return poemUpdateResultRelay
            .compactMap { $0 }
            .filter { $0.poemId != nil }
    }
    
    var poemInfoSuccess : Observable<PoemModel> {
        return poemInfoResultRelay
            .compactMap { $0 }
            .filter { $0.poemId != nil }
    }
    var todayTitleSuccess : Observable<String> {
        return todayTitleResultRelay
            .compactMap { $0 }
    }
    var likeSuccess : Observable<Int> {
        return poemLikeResultRelay
            .filter { $0 == 200 }
            .map { $0! }
    }
    
    var reportSuccess : Observable<Int> {
        return poemReportResultRelay
            .filter { $0 == 200 }
            .map { $0! }
    }
    
    
    
    init() {
        bind()
    }
    
    func bind() {
        poemListSuccess.subscribe(onNext: { list in
            list.enumerated().forEach {
                self.requestPoemInfo(wordCount: 3, poemId: $1)
            }
           
        }).disposed(by: disposeBag)
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
    
    func requestPoems(wordCount : Int) {
        requestPoemList(String(wordCount))
    }
    
    func requestPoemList(_ wordCount : String) {
        let reqModel = PoemListGetReqModel(token: Constant.shared.token, wordCount: wordCount)
        
        PoemService.requestPoemList(reqModel: reqModel, completion: {
            response in
            switch response {
            case .success(let resModel):
                if resModel.poemId!.isEmpty {
                    self.errorMessageRelay.accept("등록된 시가 없습니다")
                    return
                }
                self.poemListResultRelay.accept(resModel)
            case .failure(_):
                self.errorMessageRelay.accept("시 목록을 불러오는데 실패하였습니다.")
            }
        })
    }
    
    func requestPoemInfo(wordCount: Int, poemId : String) {
        let reqModel = PoemInfoGetReqModel(wordCount: wordCount, token: Constant.shared.token, poemId: poemId)
        
        PoemService.requestPoemInfo(reqModel: reqModel, completion: {
            response in
            switch response {
            case .success(let resModel):
                self.poemInfoResultRelay.accept(resModel)
            case .failure(_):
                self.errorMessageRelay.accept("시 정보를 불러오는데 실패하였습니다.")
            }
        })
    }
    
    func updatePoemInfo(poemId : String, wordCount : Int) {
        let reqModel = PoemInfoGetReqModel(wordCount: wordCount, token: Constant.shared.token, poemId: poemId)
        
        PoemService.requestPoemInfo(reqModel: reqModel, completion: {
            response in
            switch response {
            case .success(let resModel):
                self.poemUpdateResultRelay.accept(resModel)
            case .failure(_):
                self.errorMessageRelay.accept("시 정보를 불러오는데 실패하였습니다.")
            }
        })
    }
    
    
   
    func requestLikePoem(poemId : String, wordCount : Int) {
        print(poemId)
        PoemService.requestPoemLike(reqModel: PoemLikeReqModel(token: Constant.shared.token, poemId: poemId, wordCount: wordCount), completion: {
            response in
            switch response {
            case .success(let code):
                self.poemLikeResultRelay.accept(code)
            case .failure(_):
                self.errorMessageRelay.accept("서버에 오류가 발생하였습니다.")
            }
        })
    }
    
    func requestReportPoem(poemId : String, wordCount : Int) {
        PoemService.requestPoemReport(reqModel: PoemReportReqModel(token: Constant.shared.token, poemId: poemId, wordCount: wordCount), completion: {
            response in
            switch response {
            case .success(let code):
                self.poemReportResultRelay.accept(code)
            case .failure(_):
                self.errorMessageRelay.accept("서버에 오류가 발생하였습니다.")
            }
        })
    }
}
