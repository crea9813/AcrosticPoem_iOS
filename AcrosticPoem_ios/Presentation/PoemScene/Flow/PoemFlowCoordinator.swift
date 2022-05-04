//
//  PoemFlowCoordinator.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import UIKit

protocol PoemFlowCoordinatorDepencies {
    
    func makePoemViewController(coordinator: PoemFlowCoordinator) -> PoemViewController
    
    func makePoemAddViewController(title: String) -> PoemAddViewController
}

protocol PoemFlowCoordinator {
    
    func start()
    
    func showPoemAdds(title : String)
}

class DefaultPoemFlowCoordinator: PoemFlowCoordinator {
    
    private let navigationController: UINavigationController
    
    private let dependencies: PoemFlowCoordinatorDepencies
    
    private weak var vc: PoemViewController?
    
    init(navigationController: UINavigationController,
         dependencies: PoemFlowCoordinatorDepencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makePoemViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
        //moviesListVC = vc
    }
    
    func showPoemAdds(title: String) {
        let vc = dependencies.makePoemAddViewController(title: title)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
