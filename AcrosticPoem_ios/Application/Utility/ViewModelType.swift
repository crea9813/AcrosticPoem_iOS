//
//  ViewModelType.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/08.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
