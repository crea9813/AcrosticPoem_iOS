//
//  PoemsUseCase.swift
//  Data
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation
import Domain
import RxSwift

final class PoemsUseCase: Domain.PoemsUseCase {
    
    func poems() -> RxSwift.Single<[Domain.Poem]> {
        return Single.just([])
    }
}
