//
//  PoemViewController.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Then
import UIKit
import RxSwift
import SnapKit
import RxRelay

class PoemViewController : UIViewController {
    
    // MARK: - Vars & Lets
    
    private var viewModel: PoemViewModel!
    private let disposeBag = DisposeBag()
    
    private let didLikeButtonClicked = PublishRelay<String>()
    private let didReportButtonClicked = PublishRelay<String>()
    
    private var wordCount : Int = 3
    private var currentIndex : Int = 0
    private let poemView = UIView()
    
    static func create(with viewModel: PoemViewModel) -> PoemViewController {
        let view = PoemViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Binding
    
    private func bind() {
        assert(viewModel != nil)
        
        let viewWillAppear = self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete()
        
        let didAddButtonClicked = self.add.rx.tap.asDriver()
        
        let didLikeButtonClicked = self.didLikeButtonClicked.asDriverOnErrorJustComplete()
        
        let didReportButtonClicked = self.didReportButtonClicked.asDriverOnErrorJustComplete()
        
        let input = PoemViewModel.Input(viewWillAppear: viewWillAppear,
                                        didAddButtonClicked: didAddButtonClicked,
                                        didLikeButtonClicked: didLikeButtonClicked,
                                        didReportButtonClicked: didReportButtonClicked)
        
        let output = viewModel.transform(input: input)
        
        output.isLoading.drive(onNext: {
            isLoading in
            if isLoading { Loading.show() } else { Loading.hide() }
        }).disposed(by: disposeBag)
        
        output.error.drive(onNext: {
            [weak self] error in
            guard let self = self else { return }
            self.collectionView.setEmptyView()
        }).disposed(by: disposeBag)
        
        output.info.drive(onNext: {
            [weak self] info in
            guard let self = self else { return }
            self.todayTitle.text = info.title
        }).disposed(by: disposeBag)
        
        output.poems.drive(collectionView.rx.items(cellIdentifier: PoemCell.identifier, cellType: PoemCell.self)) {
            [weak self] index, item, cell in
            guard let self = self else { return }
            cell.configure(with: item)
            cell.action = self
        }.disposed(by: disposeBag)
        
        output.addPoem.drive().disposed(by: disposeBag)
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bind()
    }
    
    private let add = UIBarButtonItem(barButtonSystemItem: .add, target: PoemViewController.self, action: nil)
    private let titleBackgroundImage = UIImageView().then {
        $0.image = UIImage(named: "title_3")
        $0.contentMode = .scaleAspectFit
    }
    
    private let todayTitle = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "HYgsrB", size: 32)
        $0.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
    }
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.register(PoemCell.self, forCellWithReuseIdentifier: PoemCell.identifier)
        return collectionView
    }()
    
    func initView() {
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.00)
        self.navigationItem.rightBarButtonItems = [add]
        
        view.addSubview(poemView)
        
        poemView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.00)
        collectionView.backgroundColor = .clear
        poemView.addSubview(titleBackgroundImage)
        poemView.addSubview(todayTitle)
        poemView.addSubview(collectionView)
        
        poemView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleBackgroundImage.snp.makeConstraints {
            $0.width.equalTo(poemView.snp.width)
            $0.top.leading.trailing.equalTo(poemView)
        }
        
        todayTitle.snp.makeConstraints {
            $0.centerY.equalTo(titleBackgroundImage)
            $0.leading.trailing.equalTo(poemView)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleBackgroundImage.snp.bottom).inset(30)
            $0.leading.trailing.equalTo(poemView)
            $0.bottom.equalTo(poemView)
        }
    }
}

// MARK: - PoemCellAction

extension PoemViewController : PoemCellAction {
    func didLikeButtonClicked(with id: String) {
        self.didLikeButtonClicked.accept(id)
    }
    
    func didReportButtonClicked(with id: String) {
        self.didReportButtonClicked.accept(id)
    }
    
}
