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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        loadTitle()
    }
    func titleInit(titleString:String){
        //삼행시 제목 첫번째 글자 초기화
        titleFirst.font = UIFont(name: "HYgsrB", size: 27)
        titleFirst.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleFirst.text = String(titleString[titleString.startIndex])
        
        //삼행시 제목 두번째 글자 초기화
        titleSecond.font = UIFont(name: "HYgsrB", size: 27)
        titleSecond.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleSecond.text = String(titleString[titleString.index(titleString.startIndex, offsetBy: 1)])
        
        //삼행시 제목 세번째 글자 초기화
        titleThird.font = UIFont(name: "HYgsrB", size: 27)
        titleThird.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleThird.text = String(titleString[titleString.index(before: titleString.endIndex)])
    }
    fileprivate func loadTitle()
        {
    //        print(AF.request("https://acrosticpoem.azurewebsites.net/title", method: .get, parameters:["String":"String"], encoding: URLEncoding.httpBody).validate(statusCode: 200..<300))
            Alamofire.request("https://acrosticpoem.azurewebsites.net/title", method: .get).responseString {
                response in
                print("Success:",response.result)
                switch(response.result){
                case .success(_):
                    if let titleString = response.result.value{
                        print(titleString)
                        self.titleInit(titleString: titleString)
                    }
                case .failure(_):
                    print("Error", response.result.error!)
                    break
                }
                
            }
        }
}
