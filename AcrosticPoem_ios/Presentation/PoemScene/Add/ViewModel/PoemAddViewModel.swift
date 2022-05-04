//
//  PoemAddViewModel.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import RxSwift
import RxRelay

struct PoemAddViewModelAction {
    let addPoemImage : () -> Void
}

protocol PoemAddViewModelInput {
    func postPoem(word : [Word], image : String)
}

protocol PoemAddViewModelOutput {
    var success : PublishRelay<Bool> { get }
    var error : PublishRelay<String> { get }
}

final class PoemAddViewModel : PoemAddViewModelInput, PoemAddViewModelOutput {
    
    private let repo : PoemAddRepository
    
    private let disposeBag = DisposeBag()
    
    public var success: PublishRelay<Bool> = PublishRelay<Bool>()
    public var error: PublishRelay<String> = PublishRelay<String>()
    
    init(_ repo : PoemAddRepository) {
        self.repo = repo
    }
    
    public func postPoem(word: [Word], image : String) {
        repo.postPoem(param: PoemAddReqDTO(image: image, word: word, wordCount: "\(word.count)")).subscribe {
            response in
            switch response {
            case .success:
                self.success.accept(true)
            case .failure(let error):
                self.error.accept(error.localizedDescription)
            }
        }.disposed(by: disposeBag)
    }
}
