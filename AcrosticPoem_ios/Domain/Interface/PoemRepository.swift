//
//  PoemRepositoryInterface.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation
import RxSwift

protocol PoemRepository {
    func getPoemList(type : PoemType) -> Single<Poems>
    func getPoemInfo(param : PoemInfoRequestModel) -> Single<[PoemModel]>
//    func postPoemLike() -> Single<Int>
//    func postPoemReport() -> Single<Int>
}
