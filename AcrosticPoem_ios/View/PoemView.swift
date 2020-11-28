//
//  PoemView.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/24.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit

import UIKit
import SnapKit
import RxSwift

class PoemView: UIViewController {
    
    //인터페이스 빌더와 객체를 연결
//    @IBOutlet var likeButton: UIView!
//    @IBOutlet var shareButton: UIView!
//    @IBOutlet var reportButton: UIView!
//    @IBOutlet var likeCount: UILabel!
//    @IBOutlet var poemView: UIView!
//    @IBOutlet weak var titleView: UIImageView!
//    @IBOutlet var likeHeart: UIImageView!
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    
    let poemView = UIView()
    
    let titleBackgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "title_3")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var nowPage:Int = 0
    private var poemItems:Int = 0
    private let ad = UIApplication.shared.delegate as? AppDelegate
    
    private var refreshControl = UIRefreshControl()
    
    private var currentPage = 0
    
    private var poemList : [PoemModel] = []
    private var poemListOb : Observable<[PoemModel]> = Observable.just([])
    
    private var selectedPoem : PoemModel? = nil
    
    let disposeBag = DisposeBag()
    
    let viewModel = PoemViewModel()
    
    let todayTitle : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 32)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    override func viewWillLayoutSubviews() {
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        //let moreIcon = UIImage(named: "more")
        
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.93, blue: 0.89, alpha: 1.00)
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItems = [add]
        self.navigationController?.navigationBar.topItem?.title = "삼행시"
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func bind() {
        viewModel.errorMessage.subscribe(onNext : {
            error in
            let errorAlert = UIAlertController(title: "오류", message: error, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(errorAlert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        viewModel.todayTitleSuccess.subscribe(onNext: {
            title in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                self.todayTitle.text = title
                self.todayTitle.addCharacterSpacing(kernValue: 30)
            }
        }).disposed(by: disposeBag)
        
        viewModel.poemInfoSuccess.subscribe(onNext : {
            poem in
            self.poemList.append(poem)
            self.poemListOb = Observable.of(self.poemList)
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.likeSuccess.subscribe(onNext: {
            _ in
            self.updatePoem(poem: self.selectedPoem!)
        }).disposed(by: disposeBag)
        
        viewModel.reportSuccess.subscribe(onNext: {
            _ in
            print("Report Success")
        }).disposed(by: disposeBag)
        
        viewModel.poemUpdateSuccess.subscribe(onNext: {
            poem in
            self.poemList.enumerated().forEach {
                if $1.poemId!.contains(poem.poemId!) {
                    self.poemList.remove(at: $0)
                    self.poemList.insert(poem, at: $0)
                    self.collectionView.reloadItems(at: [IndexPath.init(row: $0, section: 0)])
                    let cell = self.collectionView.cellForItem(at: IndexPath.init(row: $0, section: 0)) as! PoemCell
                    cell.configure(with: poem)
                }
            }
        }).disposed(by: disposeBag)
        
        add.rx.tap.bind { [self]
            _ in
            let targetVC = PoemAddView()
            targetVC.textFieldFirst.wordView.text = "\(poemList[0].word![0].word!) :"
            targetVC.textFieldSecond.wordView.text = "\(poemList[0].word![1].word!) :"
            targetVC.textFieldThird.wordView.text = "\(poemList[0].word![2].word!) :"
            self.navigationController?.pushViewController(targetVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    //MARK: - HorizontalCollectionView 초기화
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
    
    // 페이징 이후 좋아요 갯수와 좋아요 상태 변경
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if let indexPath = carouselCollectionView.indexPathsForVisibleItems.first {
//            self.currentPage = indexPath.row
//
//            likeCount.text = String(poems[currentPage].like)
//
//            if poems[self.currentPage].liked != false {
//                likeHeart.image = UIImage(systemName: "heart.fill")
//                likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
//            } else {
//                likeHeart.image = UIImage(systemName: "heart")
//                likeHeart.tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
//            }
//        }
    }
    
    // MARK: - 뷰 초기화
    func initView() {
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

        bind()
        requestPoem()
        setCollectionView()
        setTitle()
        
    }
    
    private func requestPoem() {
        viewModel.requestPoems(wordCount: 3)
    }
    
    private func updatePoem(poem : PoemModel) {
        viewModel.updatePoemInfo(poemId: poem.poemId!, wordCount: poem.wordCount!)
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PoemCell.self, forCellWithReuseIdentifier: PoemCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
//        poemListOb.bind(to: collectionView.rx.items(cellIdentifier: PoemCell.identifier,cellType: PoemCell.self)) { index,poem,cell in
//            cell.configure(with: poem)
//        }.disposed(by: disposeBag)
//
        
    }
    
    // 삼행시 주제 설정
    private func setTitle() {
        navigationController?.title = "삼행시"
        
        viewModel.requestTodayTitle(wordCount: 3)
       /* NetworkService().todayTitle()
        .observeOn(MainScheduler.instance)
        .subscribe (
            onNext: { title in
                self.todayTitle.text = title["3"]!
                self.todayTitle.addCharacterSpacing(kernValue: 33)
            },
            onError: { error in
                switch error {
                case ApiError.unAuthorized:
                    print("unAuthorized")
                case ApiError.internalServerError:
                    print("getTitle Server Error")
                default:
                    print("Unknown Error")
                }
        }).disposed(by: disposeBag)*/
    }
}

extension PoemView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if poemList.count == 0 {
            collectionView.setEmptyView()
        } else {
            collectionView.backgroundView = nil
        }
        return poemList.count
    }
    
    // CollectionViewCell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoemCell.identifier, for: indexPath) as! PoemCell

        //TODO: 여기에 cell Configuration 하기
        cell.configure(with: poemList[indexPath.row])
        
        cell.likeButton.rx.tap.bind { _ in
            self.selectedPoem = self.poemList[indexPath.row]
            self.viewModel.requestLikePoem(poemId: self.poemList[indexPath.row].poemId!, wordCount: self.poemList[indexPath.row].wordCount!)
        }.disposed(by: disposeBag)
        
        cell.reportButton.rx.tap.bind { _ in
            if self.poemList[indexPath.row].reported! {
                AlertUtil.shared.showErrorAlert(vc: self, title: "신고하기", message: "이미 신고했어요.")
            } else {
                self.selectedPoem = self.poemList[indexPath.row]
                self.viewModel.requestReportPoem(poemId: self.poemList[indexPath.row].poemId!, wordCount: self.poemList[indexPath.row].wordCount!)
            }
        }.disposed(by: disposeBag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

