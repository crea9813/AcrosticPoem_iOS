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
    
    let poemView = UIView()
    
    let titleBackgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "title_3")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let tabView = UIView()
    let likeCount : UILabel = {
        let label = UILabel()
        
        return label
    }()
    let likeButton : UIButton = {
        let button = UIButton()
        
        return button
    }()
    let shareButton : UIButton = {
        let button = UIButton()
        
        return button
    }()
    let reportButton : UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private var nowPage:Int = 0
    private var poemItems:Int = 0
    private let ad = UIApplication.shared.delegate as? AppDelegate
    
    private var refreshControl = UIRefreshControl()
    
    private var currentPage = 0
    
    private var poems : [Poem] = []
    
    private var poemList : [PoemModel] = []
    
    let disposeBag = DisposeBag()
    
    let viewModel = PoemViewModel()
    let todayTitle : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
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
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        //let more = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(moreTapped))
        //(image: moreIcon, style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [add]
        self.navigationController?.navigationBar.topItem?.title = "삼행시"
    }
    
    @objc func addTapped() {
        let pushViewController = AddViewController()
        pushViewController.title = "작성하기"
        pushViewController.todayTitle.text = todayTitle.text
        pushViewController.wordTitleFirst.text = String(todayTitle.text![(todayTitle.text!.startIndex)])
        pushViewController.wordTitleSecond.text = String(todayTitle.text![todayTitle.text!.index(todayTitle.text!.startIndex, offsetBy: 1)])
        pushViewController.wordTitleThird.text = String(todayTitle.text![todayTitle.text!.index(before: todayTitle.text!.endIndex)])
        self.navigationController?.pushViewController(pushViewController, animated: true)
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
                self.todayTitle.addCharacterSpacing(kernValue: 33)
            }
        }).disposed(by: disposeBag)
        
        viewModel.poemInfoSuccess.subscribe(onNext : {
            poem in
            self.poemList.append(poem)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - HorizontalCollectionView 초기화
    let collectionView: UICollectionView = {
        
        // 전체 레이아웃 초기화
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

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
        view.addSubview(tabView)
        
        poemView.addSubview(titleBackgroundImage)
        poemView.addSubview(todayTitle)
        poemView.addSubview(collectionView)
        
        tabView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(view)
            $0.height.equalTo(50)
        }
        poemView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(tabView.snp.top)
        }
        
        titleBackgroundImage.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(poemView)
        }
        
        todayTitle.snp.makeConstraints {
            $0.centerY.equalTo(titleBackgroundImage)
            $0.leading.trailing.equalTo(poemView)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleBackgroundImage.snp.bottom)
            $0.leading.trailing.equalTo(poemView)
            $0.bottom.equalTo(poemView)
        }
        
        tabView.addSubview(likeButton)
        tabView.addSubview(shareButton)
        tabView.addSubview(reportButton)
        
        likeButton.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(tabView)
            $0.width.equalTo(view).dividedBy(3)
        }
        shareButton.snp.makeConstraints {
            $0.top.centerX.bottom.equalTo(tabView)
            $0.width.equalTo(view).dividedBy(3)
        }
        reportButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalTo(tabView)
            $0.width.equalTo(view).dividedBy(3)
        }
        
        setCollectionView()
        setTitle()
    }
    
    private func requestPoem() {
        
    }
    
    private func setGestureRecognizer() {
        let reportGesture = UITapGestureRecognizer(target: self, action: #selector(reportAction))
        reportButton.addGestureRecognizer(reportGesture)
        reportButton.isUserInteractionEnabled = true
        
        let likeGesture = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        likeButton.addGestureRecognizer(likeGesture)
        likeButton.isUserInteractionEnabled = true
        
        let shareGesture = UITapGestureRecognizer(target: self, action: #selector(shareAction))
        shareButton.addGestureRecognizer(shareGesture)
        shareButton.isUserInteractionEnabled = true
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PoemCell", bundle: nil), forCellWithReuseIdentifier: "PoemCell")
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
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
    
    private func setPoem(){
        
        NetworkService().getPoem()
            .observeOn(MainScheduler.instance)
        .subscribe(
            onNext: { poem in
                for count in 0..<poem.count {
                    NetworkService().poemInfo(poemId: poem[count])
                    .subscribe(
                        onNext: { info in
                            self.poems.append(info)
                        },
                        onError: { error in
                            switch error {
                            case ApiError.unAuthorized:
                                print("unAuthorized")
                            case ApiError.internalServerError:
                                print("Info Server Error")
                            default:
                                print("Unknown Error")
                            }
                    },
                        onCompleted: {
                            if count == poem.count-1 {
                                self.setCollectionView()
                            }
                    }).disposed(by: self.disposeBag)
                }
            },
            onError: { error in
                switch error {
                case ApiError.unAuthorized:
                    print("unAuthorized")
                case ApiError.internalServerError:
                    print("Poem Server Error")
                default:
                    print("Unknown Error")
                }
            }).disposed(by: disposeBag)
    }
    //MARK: - 탭바 버튼 이벤트
    @objc private func likeAction() {
        print("like Tapped")
    }
//    @objc private func likeAction() {
//        if !( poemList.isEmpty ) {
//            let poemId = poemList[currentPage].poemId
//
//            if !( poemList[currentPage].liked ) {
//                NetworkService().likePoem(poemId: poemId)
//                    .observeOn(MainScheduler.instance)
//                    .subscribe(
//                        onError: { error in
//                            switch error {
//                            case ApiError.unAuthorized:
//                                print("unAuthorized")
//                            case ApiError.internalServerError:
//                                print("Poem Server Error")
//                            default:
//                                print("Unknown Error")
//                            }
//                    },onCompleted: {
//                        self.likeHeart.image = UIImage(systemName: "heart.fill")
//                        self.likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
//                        self.carouselCollectionView.reloadData()
//                    }).disposed(by: disposeBag)
//            }
//        }
//    }
    
    @objc private func reportAction() {
        if poems.isEmpty == false {
            let poemId = poems[currentPage].poemId
            
            if !(poems[currentPage].reported) {
                NetworkService().reportPoem(poemId: poemId)
                    .observeOn(MainScheduler.instance)
                    .subscribe(
                        onError: { error in
                            switch error {
                            case ApiError.unAuthorized:
                                print("unAuthorized")
                            case ApiError.internalServerError:
                                print("Report Server Error")
                            default:
                                print("Unknown Error")
                            }
                    }, onCompleted: {
                        let alert = UIAlertController(title: "알림", message: "신고되었습니다", preferredStyle: UIAlertController.Style.alert)
                        let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
                                           alert.addAction(cancel)
                        self.present(alert, animated: false)
                    }
                ).disposed(by: disposeBag)
            }
            else{
                let alert = UIAlertController(title: "알림", message: "이미 신고된 시 입니다", preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
                alert.addAction(cancel)
                self.present(alert, animated: false)
            }
        }
    }
    
    @objc private func shareAction() {
        if !(poems.isEmpty) {
            let text = poems[currentPage].word[0].word + " : " + poems[currentPage].word[0].line + "\n" + poems[currentPage].word[1].word + " : " + poems[currentPage].word[1].line + "\n" + poems[currentPage].word[2].word + " : " + poems[currentPage].word[2].line

                let textToShare = [ text ]

                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)

                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]

                self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension PoemView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if poems.count == 0 {
            collectionView.setEmptyView()
        } else {
            collectionView.backgroundView = nil
        }
        return poems.count
    }
    
    // CollectionViewCell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoemCell.identifier, for: indexPath) as! PoemCell

        cell.titleFirst.text = poems[indexPath.row].word[0].word
        cell.titleSecond.text = poems[indexPath.row].word[1].word
        cell.titleThird.text = poems[indexPath.row].word[2].word
        cell.wordFirst.text = poems[indexPath.row].word[0].line
        cell.wordSecond.text = poems[indexPath.row].word[1].line
        cell.wordThird.text = poems[indexPath.row].word[2].line
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

