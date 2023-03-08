//
//  UseCaseProvider.swift
//  Data
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    
    public init() { }
    
    public func makePoemsUseCase() -> Domain.PoemsUseCase {
        return PoemsUseCase()
    }
}
