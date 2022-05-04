//
//  SceneDIContainer.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import UIKit
import Moya

final class SceneDIContainer {
    
    struct Dependencies {
        let service: MoyaProvider<API>
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makePoemUseCase() -> PoemUseCaseProtocol {
        return PoemUseCase(repository: makePoemRepository())
    }
    
    // MARK: - Repositories
    func makePoemRepository() -> PoemRepository {
        return DefaultPoemRepository(service: dependencies.service)
    }
    
    func makePoemAddRepository() -> PoemAddRepository {
        return DefaultPoemAddRepository(service: dependencies.service)
    }
    
    // MARK: - Movies List
    func makePoemViewController(
        coordinator: PoemFlowCoordinator
    ) -> PoemViewController {
        PoemViewController.create(
            with: makePoemViewModel(coordinator: coordinator)
        )
    }
    
    func makePoemViewModel(
        coordinator: PoemFlowCoordinator
    ) -> PoemViewModel {
        return PoemViewModel(
            makePoemUseCase(),
            coordinator: coordinator
        )
    }
    
    func makePoemAddViewController(title: String) -> PoemAddViewController {
        PoemAddViewController.create(with: makePoemAddViewModel())
    }
        
    func makePoemAddViewModel()-> PoemAddViewModel {
        return PoemAddViewModel(makePoemAddRepository())
    }
    
    // MARK: - Flow Coordinators
    func makePoemFlowCoordinator(
        navigationController: UINavigationController
    ) -> PoemFlowCoordinator {
        return DefaultPoemFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
}

extension SceneDIContainer: PoemFlowCoordinatorDepencies { }
