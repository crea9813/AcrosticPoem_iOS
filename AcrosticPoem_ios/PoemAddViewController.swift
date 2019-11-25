//
//  PoemAddViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/15.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import Alamofire

class PoemAddViewController: UIViewController{
    private var titleString: String?
    
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        networkManager.todayTitle(completionHandler: {
            result in
            self.setTitle(todayTitle: result)
        })
    }
    
    private func setTitle(todayTitle : String) {
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
}
