//
//  PoemViewModel.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import RxSwift
import RxRelay

protocol PoemViewModelInput {
    func getList(wordCount: String)
//    func didLike(at indexPath: IndexPath)
//    func didReport(at indexPath: IndexPath)
}

protocol PoemViewModelOutput {
    var items: PublishRelay<Poems> { get }
    var error: PublishRelay<String> { get }
}

final class PoemViewModel : PoemViewModelInput, PoemViewModelOutput {
    
    private let useCase : PoemUseCaseInterface
    private let coordinator: PoemFlowCoordinator
    
    let disposeBag = DisposeBag()
    
    public var items: PublishRelay<Poems> = PublishRelay<Poems>()
    
    public var error: PublishRelay<String> = PublishRelay<String>()
    
    init(_ useCase : PoemUseCaseInterface, coordinator: PoemFlowCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    public func getList(wordCount: String) {
        useCase.getPoemList(param: PoemListReqDTO(token: "", wordCount: wordCount)).subscribe {
            response in
            switch response {
            case .success(let poems):
                self.items.accept(poems)
            case .failure(let error):
                self.error.accept(error.localizedDescription)
            }
        }.disposed(by: disposeBag)
    }
    
//    public func didLike(at indexPath: IndexPath) {
//        useCase.postPoemLike()
//    }
//
//    public func didReport(at indexPath: IndexPath) {
//        useCase.postPoemReport()
//    }
}
