//
//  NetworkManager.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/25.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import Alamofire
import UIKit

class NetworkManager {
    
    private let BASE_URL:String
    private var TOKEN:String
    private let today:String
    private var count:String
    private let sort:Bool
    private var poemList:Array<String> = []
    
    init() {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMdd"
        
        BASE_URL = "https://acrosticpoem.azurewebsites.net/"
        TOKEN = UserDefaults.standard.value(forKey: "GuestToken") as! String
        today = dateFormatter.string(from: date as Date)
        count = "3"
        sort = true
    }
    
    // 토큰 생성
    private func generationToken() {
        Alamofire.request("https://acrosticpoem.azurewebsites.net/guest", method: .get).responseString {
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
    }
    // 앱 첫 실행 or 첫 실행 이후 토큰 검사
    public func launchedOption() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore
        {
            tokenValidation()
            print("첫 실행이 아님.")
        }
        else
        {
            print("앱 설치 이후 첫 실행 Guest Token 생성 중")
            generationToken()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    // 토큰 유효성 검사
    private func tokenValidation() {
        Alamofire.request(BASE_URL+"guest", method: .post, parameters: ["token" : TOKEN], encoding: JSONEncoding.default).responseString {
            response in
            switch(response.response?.statusCode){
            case 200:
                print("토큰 인증됨.")
            case 401:
                print("토큰 틀림 생성중..")
                self.generationToken()
            case 415:
                print("인코딩 형식이 잘못됨.")
            default:
                break;
            }
        }
    }
    
    //오늘의 주제 가져오기
    public func todayTitle(completionHandler: @escaping (_ result: String)->()) {
        Alamofire.request(BASE_URL+"title", method: .get).responseString {
            response in
            switch(response.result){
            case .success(_):
                if let title = response.result.value {
                    completionHandler(title)
                }
            case .failure(_):
                print(response.result.error!)
            }
        }
    }
    
    //삼행시 제출
    private func submitPoem(){
        Alamofire.request(BASE_URL+"poem", method: .post)
    }
    
    //랜덤 시 가져오기
    public func getRandomPeom(completionHandler: @escaping (_ result: [String:Any]) -> ()) {
        Alamofire.request(BASE_URL+"poem/random?date="+today+"&count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
            result in
            switch(result.result){
            case .success(_):
                if let random = result.result.value as? [String:Any] {
                    if random["poemId"] == nil {
                        print("등록된 시가 없음")
                    }else{
                        print("PoemId : ", random["poemId"] as! NSArray)
                        completionHandler(random)
                    }
                }
            case .failure(_):
                print(result.result.error!)
            }
        }
    }
    
    //추천 시 가져오기
    public func getBestPoem(completionHandler: @escaping (_ result: [String:Any]) -> ()) {
    Alamofire.request(BASE_URL+"poem/best?date="+today+"&count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
        response in
        switch(response.result){
        case .success(_):
            if let best = response.result.value as? [String:Any] {
                if best["poemId"] == nil {
                    print("등록된 시가 없음")
                }else{
                    print("PoemId : ", best["poemId"] as! [String])
                    completionHandler(best)
                }
            }
        case .failure(_):
            print(response.result.error!)
        }
        }
    }
    
    //시 정보 가져오기
    private func getPoemInfo(poemId : String){
        Alamofire.request(BASE_URL+"poem?token="+TOKEN+"&poemid="+poemId, method: .get, encoding: JSONEncoding.default).responseJSON {
            response in
            switch(response.result){
            case .success(_):
                if let poemInfo = response.result.value as? NSDictionary {
                    print(poemInfo)
                }
            case .failure(_):
                print(response.result.error!)
            }

        }
    }
    
    public func poemSort(){
        var poem:Array<String> = []
        switch(sort){
        case true:
            getRandomPeom{
                result in
                poem = result["poemId"] as! [String]
                self.getPoemInfo(poemId: poem[0])
            }
        case false:
            getBestPoem{
                result in
                poem = result["poemId"] as! [String]
                self.getPoemInfo(poemId: poem[0])
            }
        }
    }
    
    public func likePoem(poemId : String){
        Alamofire.request(BASE_URL+"poem/like", method: .post, parameters: ["token" : TOKEN, "poemId" : poemId], encoding: JSONEncoding.default).responseJSON{
            response in
            switch(response.response?.statusCode){
            case 200:
                print("삼행시 제출 성공")
            case 401:
                print("토큰 틀림")
            case 404:
                print("삼행시 없음")
            default:
                break
            }
        }
    }
    
    public func reportPoem(poemId : String){
        Alamofire.request(BASE_URL+"poem/report", method: .post, parameters: ["token" : TOKEN, "poemId" : poemId], encoding: JSONEncoding.default).responseJSON{
            response in
            switch(response.response?.statusCode){
            case 200:
                print("삼행시 제출 성공")
            case 401:
                print("토큰 틀림")
            case 404:
                print("삼행시 없음")
            case 208:
                print("이미 신고한 삼행시")
            default:
                break
            }
        }
    }
    
}
