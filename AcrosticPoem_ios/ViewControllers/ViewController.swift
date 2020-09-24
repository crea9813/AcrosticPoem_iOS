//
//  ViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/05.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    //인터페이스 빌더와 객체를 연결
    @IBOutlet var likeButton: UIView!
    @IBOutlet var shareButton: UIView!
    @IBOutlet var reportButton: UIView!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var poemView: UIView!
    @IBOutlet weak var titleView: UIImageView!
    @IBOutlet var likeHeart: UIImageView!
    
    private var nowPage:Int = 0
    private var poemItems:Int = 0
    private let ad = UIApplication.shared.delegate as? AppDelegate
    
    private var refreshControl = UIRefreshControl()
    
    private var currentPage = 0
    
    private var likeArray : [String] = []
    private var poems : [Poem] = []
    
    let disposeBag = DisposeBag()
    
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
        carouselCollectionView.reloadData()
    }
    
    //MARK: - HorizontalCollectionView 초기화
    let carouselCollectionView: UICollectionView = {
        
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
        if let indexPath = carouselCollectionView.indexPathsForVisibleItems.first {
            self.currentPage = indexPath.row
            
            likeCount.text = String(poems[currentPage].like)
            
            if poems[self.currentPage].liked != false {
                likeHeart.image = UIImage(systemName: "heart.fill")
                likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
            }else{
                likeHeart.image = UIImage(systemName: "heart")
                likeHeart.tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
                
            }
        }
    }
    
    // MARK: - 뷰 초기화
    func initView() {
        
        titleView.addSubview(todayTitle)
        
        
        todayTitle.snp.makeConstraints {
            $0.centerX.centerY.equalTo(titleView)
        }
        
        setPoem()
        setTitle()
        setGestureRecognizer()
        
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
        poemView.addSubview(carouselCollectionView)
               
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // CollectionView 오토레이아웃 설정
        carouselCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.left.right.equalTo(poemView)
            $0.bottom.equalTo(poemView)
        }
        
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(UINib(nibName: "PoemCell", bundle: nil), forCellWithReuseIdentifier: "PoemCell")
        
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.showsVerticalScrollIndicator = false
            
    }
    // 삼행시 주제 설정
    private func setTitle() {
        navigationController?.title = "삼행시"
        NetworkService().todayTitle()
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
        }).disposed(by: disposeBag)
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
        if !(poems.isEmpty) {
            let poemId = poems[currentPage].poemId
            
            if !(poems[currentPage].liked) {
                NetworkService().likePoem(poemId: poemId)
                    .observeOn(MainScheduler.instance)
                    .subscribe(
                        onError: { error in
                            switch error {
                            case ApiError.unAuthorized:
                                print("unAuthorized")
                            case ApiError.internalServerError:
                                print("Poem Server Error")
                            default:
                                print("Unknown Error")
                            }
                    },onCompleted: {
                        self.likeHeart.image = UIImage(systemName: "heart.fill")
                        self.likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
                        self.carouselCollectionView.reloadData()
                    }).disposed(by: disposeBag)
            }
        }
    }
    
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
    
extension ViewController : UICollectionViewDelegate {
    // CollectionView의 아이템 갯수
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if poems.count == 0 {
                collectionView.setEmptyView(title: "아직 등록된 시가 없습니다.", message: "첫번째로 시를 등록해봐요.")
            } else {
                collectionView.restore()
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

extension UICollectionView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "BM YEONSUNG", size: 23)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "BM YEONSUNG", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(emptyView)
            $0.centerY.equalTo(emptyView).offset(-(emptyView.frame.height/8))
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(emptyView)
        }
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
    }
    func restore() {
        self.backgroundView = nil
    }
}

