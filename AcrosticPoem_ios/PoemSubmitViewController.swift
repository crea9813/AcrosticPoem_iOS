//
//  PoemSubmitViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/25.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit

class PoemSubmitViewController : UIViewController{
    
    @IBOutlet weak var titleOne: UILabel!
    @IBOutlet weak var textfieldOne: UITextField!
    
    @IBOutlet weak var titleTwo: UILabel!
    @IBOutlet weak var textfieldTwo: UITextField!
    
    @IBOutlet weak var titleThr: UILabel!
    @IBOutlet weak var textfieldThr: UITextField!
    
    @IBOutlet weak var importImg: UIImageView!
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        networkManager.todayTitle(completionHandler: {
            result in
            self.setTitle(todayTitle: result)
        })
    }
    
    private func setTitle(todayTitle : String) {
    //        삼행시 제목 첫번째 글자 초기화
            titleOne.font = UIFont(name: "HYgsrB", size: 27)
            titleOne.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
            titleOne.text = String(todayTitle[(todayTitle.startIndex)])

            //삼행시 제목 두번째 글자 초기화
            titleTwo.font = UIFont(name: "HYgsrB", size: 27)
            titleTwo.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
            titleTwo.text = String(todayTitle[todayTitle.index(todayTitle.startIndex, offsetBy: 1)])

            //삼행시 제목 세번째 글자 초기화
            titleThr.font = UIFont(name: "HYgsrB", size: 27)
            titleThr.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
            titleThr.text = String(todayTitle[todayTitle.index(before: todayTitle.endIndex)])
        }
}
