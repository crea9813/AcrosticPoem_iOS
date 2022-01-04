//
//  FetchPoemUseCase.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/03.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation
import RxSwift

protocol PoemUseCaseInterface {
    func getPoemList(param : PoemListReqDTO) -> Single<Poems>
    func getPoemInfo(param : PoemReqDTO) -> Single<PoemModel>
//    func postPoemLike() -> Single<Int>
//    func postPoemReport() -> Single<Int>
}

final class PoemUseCase: PoemUseCaseInterface {

    private let repository: PoemRepository

    init(repository: PoemRepository) {
        self.repository = repository
    }

    public func getPoemList(param : PoemListReqDTO) -> Single<Poems> {
        return repository.getPoemList(param: param)
    }
    
    public func getPoemInfo(param : PoemReqDTO) -> Single<PoemModel> {
        return repository.getPoemInfo(param: param)
    }
    
//    public func postPoemLike() -> Single<Int> {
//        return repository.postPoemLike()
//    }
//    
//    public func postPoemReport() -> Single<Int> {
//        return repository.postPoemReport()
//    }
}



