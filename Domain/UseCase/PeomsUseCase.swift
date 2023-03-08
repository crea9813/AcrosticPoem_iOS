//
//  PeomsUseCase.swift
//  Domain
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation
import RxSwift

public protocol PoemsUseCase {
    func poems() -> Single<[Poem]>
}
