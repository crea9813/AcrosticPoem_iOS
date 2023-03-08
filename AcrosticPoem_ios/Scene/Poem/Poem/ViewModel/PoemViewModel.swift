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

protocol PoemViewModelInput {
    func getList(wordCount: String)
    //    func didLike(at indexPath: IndexPath)
    //    func didReport(at indexPath: IndexPath)
}

protocol PoemViewModelOutput {
    var items: PublishRelay<Poems> { get }
    var error: PublishRelay<String> { get }
}
//
//final class PoemViewModel : PoemViewModelInput, PoemViewModelOutput {
//
//    private let useCase : PoemUseCaseProtocol
//    private let coordinator: PoemFlowCoordinator
//
//    let disposeBag = DisposeBag()
//
//    public var items: PublishRelay<Poems> = PublishRelay<Poems>()
//
//    public var error: PublishRelay<String> = PublishRelay<String>()
//
//    init(_ useCase : PoemUseCaseProtocol, coordinator: PoemFlowCoordinator) {
//        self.useCase = useCase
//        self.coordinator = coordinator
//
//        getList(wordCount: "3")
//    }
//
//    public func getList(wordCount: String) {
//        useCase.getPoemList(param: PoemListRequestModel(token: "", wordCount: wordCount)).subscribe {
//            response in
//            switch response {
//            case .success(let poems):
//                self.items.accept(poems)
//            case .failure(let error):
//                self.error.accept(error.localizedDescription)
//            }
//        }.disposed(by: disposeBag)
//    }
//
////    public func didLike(at indexPath: IndexPath) {
////        useCase.postPoemLike()
////    }
////
////    public func didReport(at indexPath: IndexPath) {
////        useCase.postPoemReport()
////    }
//}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

enum PoemType : Int {
    case two = 2
    case three = 3
    case four = 4
}

final class PoemViewModel: ViewModelType {
    
    // MARK: - Vars & Lets
    private let poemType = BehaviorRelay<PoemType>(value: .three)
    private let useCase : PoemUseCaseProtocol
    private let coordinator: PoemFlowCoordinator
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(_ useCase : PoemUseCaseProtocol, coordinator: PoemFlowCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    // MARK: - Input & Output
    
    struct Input {
        let viewWillAppear : Observable<Void>
        let didAddButtonClicked: Observable<Void>
        let didLikeButtonClicked: Observable<String>
        let didReportButtonClicked: Observable<String>
    }
    
    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let info: Driver<Poems>
        let poems: Driver<[PoemModel]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let loadingTracker = BehaviorRelay<Bool>(value: false)
        
        let info = input.viewWillAppear.withLatestFrom(self.poemType).flatMapLatest { [unowned self] type -> Observable<Poems> in
            loadingTracker.accept(true)
            return self.useCase.getPoemList(type: type)
                .trackError(errorTracker)
                .do(onError: {
                    _ in
                    loadingTracker.accept(false)
                })
                .catchErrorJustComplete()
        }
        
        let poems = info.map { $0.poemID }.flatMapLatest { [unowned self] list -> Observable<[PoemModel]> in
            return self.useCase.getPoemInfo(param: PoemInfoRequestModel(wordCount: self.poemType.value.rawValue, id: list))
                .trackError(errorTracker)
                .do(onNext: {
                    _ in
                    loadingTracker.accept(false)
                }, onError: {
                    _ in
                    loadingTracker.accept(false)
                })
                .catchErrorJustComplete()
        }
        
        input.didAddButtonClicked.withLatestFrom(info).bind {
            [weak self] info in
            guard let self = self else { return }
            self.coordinator.showPoemAdds(title: info.title)
        }.disposed(by: disposeBag)
        
        return Output(error: errorTracker.asDriver(),
                      isLoading: loadingTracker.asDriver(),
                      info: info.asDriverOnErrorJustComplete(),
                      poems: poems.asDriver(onErrorJustReturn: []))
    }
}



final class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}


extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
