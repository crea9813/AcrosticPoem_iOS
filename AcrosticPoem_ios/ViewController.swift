//
//  ViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/05.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController
{
    private var titleString: String?
    //인터페이스 빌더와 객체를 연결
    @IBOutlet var likeButton: UIView!
    @IBOutlet var shareButton: UIView!
    @IBOutlet var reportButton: UIView!
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    // ! 는 Unwraping 하는 구문 변수가 nil 이 되진 않을 명확한 약속이 없을 때 사용
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backgroundInit()
        loadTitle()
    }
    
    private func titleInit(titleString: String){
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

