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
    
    var poemInfo : [PoemModel] = [PoemModel(imageUrl: "", titleFirst: "삼", titleSecond: "행", titleThird: "시", wordFirst: "삼", wordSecond: "행", wordThird: "시"),
                                  PoemModel(imageUrl: "", titleFirst: "삼", titleSecond: "행", titleThird: "시", wordFirst: "삼", wordSecond: "행", wordThird: "시")]
    
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
        return CGSize(width: view.frame.width - 80, height: view.frame.height - 300)
    }
    
    // ! 는 Unwraping 하는 구문 변수가 nil 이 되진 않을 명확한 약속이 없을 때 사용
    override func viewDidLoad()
    {
        DispatchQueue.global().sync {
            networkManager.todayTitle(completionHandler: {
                result in
                self.setTitle(todayTitle: result)
            })
        }
        
//        self.numberOfItems = networkManager.getPoemList()
        super.viewDidLoad()
        backgroundInit()
        getPoem()
    }
    
    func getPoem(){
        var poem:Array<String> = []
        
        networkManager.getRandomPeom{
            result in
            poem = result["poemId"] as! [String]
            for count in 0..<poem.count {
                self.networkManager.getPoemInfo(poemId: poem[count]){
                    result in
                    print(result["word"])
                }
            }
        }
    }
    
    public func setTitle(todayTitle : String) {
        print("오늘의 주제 :", todayTitle)
//        삼행시 제목 첫번째 글자 초기화
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
    
    private func backgroundInit(){
        //배경 색상 지정
        self.view.backgroundColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
//
        poemView.addSubview(carouselCollectionView)
        carouselCollectionView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(titleView.snp.bottom).inset(8)
            make.left.equalTo(poemView).offset(0)
            make.bottom.equalTo(poemView).offset(-8)
            make.right.equalTo(poemView).offset(0)
        }
////
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(UINib.init(nibName: "PoemCell", bundle: nil), forCellWithReuseIdentifier: "PoemCell")
//        carouselCollectionView.register(UINib.init(nibName: "PoemCell", bundle: nil), forCellWithReuseIdentifier: "PoemCell")
//        carouselCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
         
    }
}

final class CVCell: UICollectionViewCell {
  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 40.0)
    label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
