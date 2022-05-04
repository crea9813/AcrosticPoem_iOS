//
//  PoemRepository.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//


import Foundation
import Moya
import RxSwift

final class DefaultPoemRepository : PoemRepository {
    
    private let service : PoemService
    
    init(service : PoemService) {
        self.service = service
    }
    
    func getPoemList(type: PoemType) -> Single<Poems> {
        return service.rx.request(.getPoemList(type: type))
            .catchAPIError(APIErrorResponse.self)
              .filterSuccessfulStatusCodes()
            .map(PoemListResDTO.self)
            .map { $0.toDomain() }
    }
    
    func getPoemInfo(param : PoemInfoRequestModel) -> Single<[PoemModel]> {
        let poemObservables = param.id.map { getPoemInfo(type: param.wordCount, id: $0).asObservable() }
        
        return Observable.merge(poemObservables).asSingle()
        
    }
    
    private func getPoemInfo(type: Int, id: String) -> Single<[PoemModel]>{
        return service.rx.request(.getPoemInfo(type: type, id: id))
            .catchAPIError(APIErrorResponse.self)
              .filterSuccessfulStatusCodes()
            .map(PoemResDTO.self)
            .map { [$0.toDomain()] }
    }
    
//    func postPoemLike() -> Single<Int> {
//        
//    }
//    
//    func postPoemReport() -> Single<Int> {
//        
//    }
}




typealias PoemService = MoyaProvider<API>
