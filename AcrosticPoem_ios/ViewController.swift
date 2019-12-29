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
    @IBOutlet var poemView: UIView!
    @IBOutlet weak var titleView: UIImageView!
    
    let BASE_URL = "http://149.28.22.157:4568/"
    var nowPage:Int = 0
    var poemItems:Int = 0
    var networkManager = NetworkManager()
    var todayTitle = ""
    
    var poemInfo : [PoemModel] = []
    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        DispatchQueue.global().async {
            self.networkManager.todayTitle(completionHandler: {
                result in
                self.setTitle(todayTitle: result)
            })
        }
        var poem:Array<String> = []
        
        DispatchQueue.global().async {
            self.networkManager.getRandomPeom{
                result in
                poem = result["poemId"] as! [String]
                for count in 0..<poem.count {
                    NetworkManager().getPoemInfo(poemId: poem[count]) {
                        result in
                        print(result)
                        
                        let wordObj = result["word"].arrayValue.map{
                            $0["line"].stringValue
                        }
                        
                        print(wordObj)
                        self.poemInfo.append(PoemModel(imageUrl: result["image"].stringValue, titleFirst: self.titleFirst.text!, titleSecond: self.titleSecond.text!, titleThird: self.titleThird.text!, wordFirst: "", wordSecond: "", wordThird: ""))
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
    
}
