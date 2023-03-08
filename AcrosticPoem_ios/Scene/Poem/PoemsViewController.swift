//
//  PoemsViewController.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Shuffle_iOS

class PoemsViewController: UIViewController {
    
    private var viewModel: PoemsViewModel!
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.text = "오늘의 삼행시는"
        $0.textColor = .black
    }
    
    private let poemTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.text = "삼행시"
        $0.textColor = .black
    }
    
    private let cardView = SwipeCardStack()
    
    private let createPoemButton = UIButton()
    
    static func create(with viewModel: PoemsViewModel) -> PoemsViewController {
        let view = PoemsViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
    }
    
    private func bind() {
        assert(viewModel != nil)
        
        let didCreatePoemClicked = self.createPoemButton.rx.tap.asDriver()
        
        let didLikePeom = self.cardView.rx.modelSelected(PoemItemViewModel.self).asDriver()
        
        
        let input = PoemsViewModel.Input(didCreatePoemClicked: didCreatePoemClicked,
                                         didLikePoem: didLikePeom)
        
        let output = viewModel.transform(input: input)
        
        Driver.just(3).map { wordCount -> String in
            switch wordCount {
            case 2: return "이행시"
            case 3: return "삼행시"
            case 4: return "사행시"
            default: return "행시"
            }
        }.drive(onNext: {
            [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = "오늘의 \($0)는"
        }).disposed(by: disposeBag)
        
        Driver.just("개발자")
            .drive(onNext: {
                [weak self] in
                guard let self = self else { return }
                self.poemTitleLabel.text = $0
            }).disposed(by: disposeBag)
        
        
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        [titleLabel, poemTitleLabel, cardView, createPoemButton]
            .forEach {
                self.view.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.leading.equalToSuperview().inset(22)
        }
        
        poemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(22)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(poemTitleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(cardView.snp.width)
        }
        
        createPoemButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(46)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(60)
        }
    }
}
