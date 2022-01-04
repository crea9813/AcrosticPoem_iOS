//
//  DefaultPoemAddRepository.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation
import Moya
import RxSwift

final class DefaultPoemAddRepository : PoemAddRepository {
    
    private let service : PoemService
    
    init(service : PoemService) {
        self.service = service
    }
    
    func postPoem(param: PoemAddReqDTO) -> Single<Bool> {
        return service.rx.request(.addPoem(reqModel: param))
            .catchAPIError(APIErrorResponse.self)
            .filterSuccessfulStatusCodes()
            .map(Bool.self)
        
    }
    
    
}
