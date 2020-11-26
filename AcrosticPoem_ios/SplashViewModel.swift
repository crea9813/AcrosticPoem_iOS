//
//  SplashViewModel.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/26.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import RxSwift
import RxRelay

class SplashViewModel {
    
    private let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    private let tokenResultRelay = BehaviorRelay<String?>(value: nil)
    private let validateResultRelay = BehaviorRelay<Int?>(value: nil)
    
    var errorMessage : Observable<String> {
        return errorMessageRelay
            .compactMap { $0 }
    }
    
    var tokenSuccess : Observable<String> {
        return tokenResultRelay
            .compactMap { $0 }
    }
    
    var validateSuccess : Observable<Int> {
        return validateResultRelay
            .filter { $0 == 200 }
            .map { $0! }
    }
    
    func requestToken() {
        UserService.requestToken(completion: {
            response in
            switch response {
            case .success(let token):
                self.tokenResultRelay.accept(token)
            case .failure(_):
                self.errorMessageRelay.accept("게스트로 접속하는데 실패하였습니다.")
            }
        })
    }
    
    func validateToken(token : String) {
        UserService.validateToken(token: token, completion: {
            response in
            switch response {
            case .success(let code):
                if code == 200 {
                    self.validateResultRelay.accept(code)
                } else {
                    self.errorMessageRelay.accept("서버에 접속하는데 실패하였습니다.")
                }
            case .failure(_):
                self.errorMessageRelay.accept("로그인 하는데 실패하였습니다.")
            }
        })
    }
}
