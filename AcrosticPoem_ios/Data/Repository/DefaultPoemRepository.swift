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
    
    func getPoemList(param : PoemListReqDTO) -> Single<Poems> {
        
        return service.rx.request(.getPoemList(reqModel: param))
            .catchAPIError(APIErrorResponse.self)
              .filterSuccessfulStatusCodes()
            .map(PoemListResDTO.self)
            .map { $0.toDomain() }
    }
    
    func getPoemInfo(param : PoemReqDTO) -> Single<PoemModel> {
        return service.rx.request(.getPoemInfo(reqModel: param))
            .catchAPIError(APIErrorResponse.self)
              .filterSuccessfulStatusCodes()
            .map(PoemResDTO.self)
            .map { $0.toDomain() }
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
