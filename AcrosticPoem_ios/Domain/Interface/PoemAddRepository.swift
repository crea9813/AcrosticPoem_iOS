//
//  PoemAddRepository.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation
import RxSwift

protocol PoemAddRepository {
    func postPoem(param : PoemAddReqDTO) -> Single<Bool>
}
