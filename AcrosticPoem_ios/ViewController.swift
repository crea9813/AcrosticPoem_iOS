//
//  ViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/05.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import Alamofire
import InfiniteCarouselCollectionView

class ViewController: UIViewController
{
    //인터페이스 빌더와 객체를 연결
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var likeButton: UIView!
    @IBOutlet var shareButton: UIView!
    @IBOutlet var reportButton: UIView!
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    
    var nowPage:Int = 0
    var peomItems = [""]
    var networkManager = NetworkManager()
    var todayTitle = ""
    
    // ! 는 Unwraping 하는 구문 변수가 nil 이 되진 않을 명확한 약속이 없을 때 사용
    override func viewDidLoad()
    {
        networkManager.todayTitle(completionHandler: {
            result in
            self.setTitle(todayTitle: result)
        })
        
        super.viewDidLoad()
        backgroundInit()
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
        
    }
    private func collectionViewInit(){
//        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        // 스크롤 시 빠르게 감속 되도록 설정
//        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
}
