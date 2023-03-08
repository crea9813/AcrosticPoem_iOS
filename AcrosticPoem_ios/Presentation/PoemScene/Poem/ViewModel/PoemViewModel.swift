//
//  PoemViewModel.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import RxSwift
import RxRelay
import RxCocoa

enum PoemType : Int {
    case two = 2
    case three = 3
    case four = 4
}

final class PoemViewModel: ViewModelType {
    
    // MARK: - Vars & Lets
    private let useCase: PoemUseCaseProtocol
    private let coordinator: PoemFlowCoordinator
    // MARK: - Init
    
    init(_ useCase : PoemUseCaseProtocol, coordinator: PoemFlowCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    // MARK: - Input & Output
    
    struct Input {
        let viewWillAppear: Driver<Void>
        let didAddButtonClicked: Driver<Void>
        let didLikeButtonClicked: Driver<String>
        let didReportButtonClicked: Driver<String>
    }
    
    struct Output {
        let error: Driver<Error>
        
        let isLoading: Driver<Bool>
        
        let info: Driver<Poems>
        
        let poems: Driver<[PoemModel]>
        
        let addPoem: Driver<String>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let loadingTracker = LoadingTracker()
        
        let poemType = Driver<PoemType>.just(.three)
        
        let info = input.viewWillAppear
            .withLatestFrom(poemType)
            .flatMapLatest { [unowned self] type -> Driver<Poems> in
                return self.useCase.getPoemList(type: type)
                    .trackError(errorTracker)
                    .trackActivity(loadingTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let poems = info
            .map { return PoemInfoRequestModel(wordCount: $0.title.count, id: $0.poemID) }
            .flatMapLatest { [unowned self] poems -> Driver<[PoemModel]> in
                return self.useCase.getPoemInfo(param: poems)
                    .trackError(errorTracker)
                    .trackActivity(loadingTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let addPoem = input.didAddButtonClicked
            .withLatestFrom(info)
            .map { $0.title }
            .do(onNext: self.coordinator.showPoemAdds(title:))
        
        return Output(error: errorTracker.asDriver(),
                      
                      isLoading: loadingTracker.asDriver(),
                      
                      info: info,
                      
                      poems: poems,
                      
                      addPoem: addPoem)
    }
}


