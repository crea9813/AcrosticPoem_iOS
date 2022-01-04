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

class PoemViewController : UIViewController, StoryboardInstantiable {
    
    private var viewModel: PoemViewModel!
    private var disposeBag = DisposeBag()
    
    private var wordCount : Int = 3
    private var currentIndex : Int = 0
    private let poemView = UIView()
    
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    let titleBackgroundImage = UIImageView().then {
        $0.image = UIImage(named: "title_3")
        $0.contentMode = .scaleAspectFit
    }
    
    let todayTitle = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "HYgsrB", size: 32)
        $0.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
    }
    
    let collectionView: UICollectionView = {
        
        // 전체 레이아웃 초기화
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0

        // CollectionView 초기화
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        
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
    
    private func bind() {
        assert(viewModel != nil)
        
        
        
        
        viewModel.items.bind {
            items in
            print(items)
        }.disposed(by: disposeBag)
        
        viewModel.getList(wordCount: "\(self.wordCount)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bind()
    }
    
    static func create(with viewModel: PoemViewModel) -> PoemViewController {
        let view = PoemViewController()
        view.viewModel = viewModel
        return view
    }
    
    
}
