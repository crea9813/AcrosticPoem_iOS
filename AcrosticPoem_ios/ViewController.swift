//
//  ViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/05.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
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
    
    
    let BASE_URL = "http://149.28.22.157:4568/"
    var nowPage:Int = 0
    var poemItems:Int = 0
    let ad = UIApplication.shared.delegate as? AppDelegate
    var networkManager = NetworkManager()
    var todayTitle = ""
    var currentPage = 0
    
    var poemInfo : [PoemModel] = []
    var likeArray : [String] = []
    
    //Carousel 뷰 설정
    let carouselCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 26
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        
        
        return collectionView
    }()
    
    //셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return poemInfo.count
    }
    
    //셀 스타일
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0) 
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PoemCell", for: indexPath) as! PoemCell
        cell.configure(with: poemInfo[indexPath.row])
        return cell
    }
    
    //셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 80, height: poemView.frame.height - 130)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = carouselCollectionView.indexPathsForVisibleItems.first {
            self.currentPage = indexPath.row
            
            likeCount.text = poemInfo[self.currentPage].like
            if poemInfo[self.currentPage].liked != false {
                likeHeart.image = UIImage(systemName: "heart.fill")
                likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
            }else{
                likeHeart.image = UIImage(systemName: "heart")
                likeHeart.tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
                
            }
        }
        print(self.currentPage)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        let reportGesture = UITapGestureRecognizer(target: self, action: #selector(reportAction))
        reportButton.addGestureRecognizer(reportGesture)
        reportButton.isUserInteractionEnabled = true
        
        let likeGesture = UITapGestureRecognizer(target: self, action: #selector(likeAction))
        likeButton.addGestureRecognizer(likeGesture)
        likeButton.isUserInteractionEnabled = true
        
        let shareGesture = UITapGestureRecognizer(target: self, action: #selector(shareAction))
        shareButton.addGestureRecognizer(shareGesture)
        shareButton.isUserInteractionEnabled = true
        
        DispatchQueue.global().async {
            self.networkManager.todayTitle(completionHandler: {
                result in
                self.ad?.titleString = result
                self.setTitle(todayTitle: result)
            })
        }
        var poem:Array<String> = []
        
        DispatchQueue.global().async {
            self.networkManager.getRandomPeom{
                result in
                poem = result["poemId"] as! [String]
                for count in 0..<poem.count {
                    NetworkManager().getPoemInfo(poemId: poem[count]){
                        result in
                        print(result)
                        
                        //단어 파싱
                        let wordObj = result["word"].arrayValue.map{
                            $0["line"].stringValue
                        }
                        
                        //배열에 넣기
                        self.poemInfo.append(PoemModel(imageUrl: result["image"].stringValue, titleFirst: self.titleFirst.text!, titleSecond: self.titleSecond.text!, titleThird: self.titleThird.text!, wordFirst: wordObj[0], wordSecond: wordObj[1], wordThird: wordObj[2],poemId: result["poemId"].stringValue, reported: result["reported"].boolValue, like: result["like"].stringValue, liked: result["liked"].boolValue))
                        
                        //좋아요 개수
                        self.likeArray.append(result["like"].stringValue)
                        
                        self.likeCount.text = self.likeArray[0]
                        
                        self.carouselCollectionView.reloadData()
                    }
                }
            }
        }
        
        self.view.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)

        //CarouselCollectionView
        poemView.addSubview(carouselCollectionView)
        carouselCollectionView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(titleView.snp.bottom).inset(8)
            make.left.equalTo(poemView).offset(0)
            make.bottom.equalTo(poemView).offset(-8)
            make.right.equalTo(poemView).offset(0)
        }
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(UINib.init(nibName: "PoemCell", bundle: nil), forCellWithReuseIdentifier: "PoemCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
    }
    
    public func setTitle(todayTitle : String) {
        print("오늘의 주제 :", todayTitle)
        //삼행시 제목 첫번째 글자 초기화
        titleFirst.font = UIFont(name: "HYgsrB", size: 27)
        titleFirst.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleFirst.text = String(todayTitle[(todayTitle.startIndex)])
        
        //삼행시 제목 두번째 글자 초기화
        titleSecond.font = UIFont(name: "HYgsrB", size: 27)
        titleSecond.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleSecond.text = String(todayTitle[todayTitle.index(todayTitle.startIndex, offsetBy: 1)])
        
        //삼행시 제목 세번째 글자 초기화
        titleThird.font = UIFont(name: "HYgsrB", size: 27)
        titleThird.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleThird.text = String(todayTitle[todayTitle.index(before: todayTitle.endIndex)])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc private func likeAction() {
        let poemId = poemInfo[currentPage].poemId
        if poemInfo[currentPage].liked != true {
            networkManager.likePoem(poemId: poemId)
            likeHeart.image = UIImage(systemName: "heart.fill")
            likeHeart.tintColor = UIColor(red: 0.84, green: 0.35, blue: 0.29, alpha: 1)
            carouselCollectionView.reloadItems(at: carouselCollectionView.indexPathsForVisibleItems)
        }else{
            print("이미 좋아요 된 시")
        }
    }
    
    @objc private func reportAction() {
        print(poemInfo[currentPage].poemId)
        let poemId = poemInfo[currentPage].poemId
        if poemInfo[currentPage].reported != true {
            networkManager.reportPoem(poemId: poemId)
            let alert = UIAlertController(title: "알림", message: "신고되었습니다", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
            alert.addAction(cancel)
            self.present(alert, animated: false)
        }
        else{
            print("이미 신고된 삼행시")
            let alert = UIAlertController(title: "알림", message: "이미 신고된 시 입니다", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
            alert.addAction(cancel)
            self.present(alert, animated: false)
        }
    }
    
    @objc private func shareAction() {
        print("공유하기")
        
        let text = poemInfo[currentPage].titleFirst + " : " + poemInfo[currentPage].wordFirst + "\n" + poemInfo[currentPage].titleSecond + " : " + poemInfo[currentPage].wordSecond + "\n" + poemInfo[currentPage].titleThird + " : " + poemInfo[currentPage].wordThird
        
        let textToShare = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}
