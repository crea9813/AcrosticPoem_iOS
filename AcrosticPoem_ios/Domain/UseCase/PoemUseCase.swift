//
//  FetchPoemUseCase.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/03.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation
import RxSwift

protocol PoemUseCaseProtocol {
    func getPoemList(type : PoemType) -> Single<Poems>
    func getPoemInfo(param : PoemInfoRequestModel) -> Single<[PoemModel]>
//    func postPoemLike() -> Single<Int>
//    func postPoemReport() -> Single<Int>
}

final class PoemUseCase: PoemUseCaseProtocol {

    private let repository: PoemRepository

    init(repository: PoemRepository) {
        self.repository = repository
    }

    public func getPoemList(type : PoemType) -> Single<Poems> {
        return repository.getPoemList(type: type)
    }
    
    public func getPoemInfo(param : PoemInfoRequestModel) -> Single<[PoemModel]> {
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

struct PoemInfoRequestModel {
    let wordCount: Int
    let id: [String]
}



