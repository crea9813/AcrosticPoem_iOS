//
//  AppDiContainer.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//
import Moya
import Foundation


final class AppDIContainer {
    
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer.Dependencies(service: MoyaProvider<API>())
        return SceneDIContainer(dependencies: dependencies)
    }
    
}
