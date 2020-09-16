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
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var poemView: UIView!
    @IBOutlet weak var titleView: UIImageView!
    @IBOutlet var likeHeart: UIImageView!
    
    private var nowPage:Int = 0
    private var poemItems:Int = 0
    private let ad = UIApplication.shared.delegate as? AppDelegate
    private var networkManager = NetworkManager()
    private var refreshControl = UIRefreshControl()
    
    private var currentPage = 0
    
    private var likeArray : [String] = []
    private var poems : [Poem] = []
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        initView()
    }
    
    //MARK: - HorizontalCollectionView 초기화
    let carouselCollectionView: UICollectionView = {
        
        // 전체 레이아웃 초기화
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 26
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
        
        if #available(iOS 10.0, *) {
            carouselCollectionView.refreshControl = refreshControl
        } else {
            carouselCollectionView.addSubview(refreshControl)
        }
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.showsVerticalScrollIndicator = false
            
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    // 삼행시 주제 설정
    private func setTitle() {
        NetworkService().todayTitle()
        .observeOn(MainScheduler.instance)
        .subscribe (
            onNext: { title in
                let todayTitle = title["3"]!
                
                self.titleFirst.font = UIFont(name: "HYgsrB", size: 27)
                self.titleFirst.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
                self.titleFirst.text = String(todayTitle[(todayTitle.startIndex)])
                
                //삼행시 제목 두번째 글자 초기화
                self.titleSecond.font = UIFont(name: "HYgsrB", size: 27)
                self.titleSecond.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
                self.titleSecond.text = String(todayTitle[todayTitle.index(todayTitle.startIndex, offsetBy: 1)])
                
                //삼행시 제목 세번째 글자 초기화
                self.titleThird.font = UIFont(name: "HYgsrB", size: 27)
                self.titleThird.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
                self.titleThird.text = String(todayTitle[todayTitle.index(before: todayTitle.endIndex)])
            },
            onError: { error in
                switch error {
                case ApiError.unAuthorized:
                    print("unAuthorized")
                case ApiError.internalServerError:
                    print("Server Error")
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
                                print("Server Error")
                            default:
                                print("Unknown Error")
                            }
                    },
                        onCompleted: {
                            if count == poem.count-1 {
                                print(self.poems)
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
                    print("Server Error")
                default:
                    print("Unknown Error")
                }
            }).disposed(by: disposeBag)
    }
    //MARK: - 탭바 버튼 이벤트
    @objc private func likeAction() {
        
        if poems.isEmpty == false {
            let poemId = poems[currentPage].poemId
            if poems[currentPage].liked != true {
                networkManager.likePoem(poemId: poemId)
                likeHeart.image = UIImage(systemName: "heart.fill")
                likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
                self.carouselCollectionView.reloadData()
            }else{
                
            }
        }
    }
    
    @objc private func reportAction() {
        
        if poems.isEmpty == false {
            let poemId = poems[currentPage].poemId
            if poems[currentPage].reported != true {
                networkManager.reportPoem(poemId: poemId)
                let alert = UIAlertController(title: "알림", message: "신고되었습니다", preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
                alert.addAction(cancel)
                self.present(alert, animated: false)
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
//        if poems.isEmpty == false {
//            let text = poems[currentPage].titleFirst + " : " + poems[currentPage].wordFirst + "\n" + poems[currentPage].titleSecond + " : " + poems[currentPage].wordSecond + "\n" + poems[currentPage].titleThird + " : " + poems[currentPage].wordThird
//
//                let textToShare = [ text ]
//
//                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//
//                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
//
//                self.present(activityViewController, animated: true, completion: nil)
//
//            }
        }
    
    @objc private func refresh() {
        setPoem()
        refreshControl.endRefreshing()
    }
    
    // MARK: - 등록 이후 뷰 초기화
    // FIXME: - 현재 작동 안함.. 버그
    
    // 뷰 이동을 위한 함수
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue){
        setPoem()
    }
}

extension ViewController : UICollectionViewDelegate {
    // CollectionView의 아이템 갯수
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return poems.count
        }
        // CollectionViewCell 설정
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    //        cell.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
    //        return cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoemCell.identifier, for: indexPath) as! PoemCell

            cell.titleFirst.text = titleFirst.text
            cell.titleSecond.text = titleSecond.text
            cell.titleThird.text = titleThird.text
            cell.wordFirst.text = poems[indexPath.row].word[0].line
            cell.wordSecond.text = poems[indexPath.row].word[1].line
            cell.wordThird.text = poems[indexPath.row].word[2].line
            
            return cell
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
