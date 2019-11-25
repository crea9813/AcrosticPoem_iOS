//
//  ExtractPoemList.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/18.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import Alamofire
import UIKit

public class ExtractPoemList {
    
    private let BASE_URL = "https://acrosticpoem.azurewebsites.net/"
    
    var liked:Bool = false
    var word:Any = ""
    
    
    
    var today = ""
    var count:String = "5"
    var data:Array = [""]
    var guestToken = ""
    
    init() {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMdd"
        self.today = dateFormatter.string(from: date as Date)
        getToken()
        addList(Sort: true)
        print("Today : ",self.today)
        print("Your GuestToken: ",self.guestToken)
    }
    
    private func getToken(){
        if (UserDefaults.standard.value(forKey: "GuestToken") != nil) {
            self.guestToken = UserDefaults.standard.value(forKey: "GuestToken") as! String
        }else{
            print("GuestToken not exist")
        }
    }
    
    
    private func validation(completionHandler: @escaping (_ result: String)->()){
        Alamofire.request(self.BASE_URL + "guest", method: .post, parameters: ["token" : guestToken], encoding: JSONEncoding.default).responseString{
            response in
            //상태 코드 반환
            print(response.response?.statusCode as Any)
            switch(response.response?.statusCode){
            case 200:
                print("Token Validated")
            case 401:
                print("Unauthorized")
                Alamofire.request(self.BASE_URL+"guest", method: .get).responseString {
                    response in
                    switch(response.result){
                    case .success(_):
                        if let guestToken = response.result.value{
                            UserDefaults.standard.set(guestToken, forKey: "GuestToken")
                        }
                    case .failure(_):
                        print(response.result.error!)
                    }
                }
            default: break
                
            }
        }
    }
    
    //랜덤 시 리스트 가져오기
    private func randomPoemList(completionHandler: @escaping (_ result: [String:Any]) -> ()) {
        Alamofire.request(self.BASE_URL + "poem/random?date="+today+"&count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
            response in
            if let list = response.result.value as? [String:Any] {
                completionHandler(list)
            }
        }
    }
    
    //추천 수 시 리스트 가져오기
    private func BestPoemList(completionHandler: @escaping (_ result: [String:Any]) -> ()){
        Alamofire.request(BASE_URL + "poem/best?date="+today+"&count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
            response in
            if let list = response.result.value as? [String:Any] {
                completionHandler(list)
            }
        }
    }
    
    public func getInformation(nowPoem : Int){
        Alamofire.request(self.BASE_URL + "poem?token="+self.guestToken+"&poemid="+self.data[nowPoem], method: .get, encoding: JSONEncoding.default).responseJSON {
            response in
            switch(response.result){
            case .success(_):
                self.word = response.result.value as! NSDictionary
                print(self.word)
            case .failure(_):
                print(response.result.error!)
            }
            
        }
    }
    
    public func addList(Sort : Bool){
        switch(Sort){
        case true:
            randomPoemList{
                (result) in
                print(result)
                self.data = result["poemId"] as! [String]
            }
        case false:
            BestPoemList{
                result in
                self.data = result["poemId"] as! [String]
                print(self.data)
            }
        }
    }
}
