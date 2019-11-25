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
    private var today:String
    private var count:String
    init() {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMdd"
        
        
        BASE_URL = "https://acrosticpoem.azurewebsites.net/"
        TOKEN = UserDefaults.standard.value(forKey: "GuestToken") as! String
        today = dateFormatter.string(from: date as Date)
        count = "3"
        
        getRandomPeom()
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
    private func launchedOption() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore
        {
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
        Alamofire.request(BASE_URL+"guest", method: .post, parameters: ["token" : TOKEN]).responseString {
            response in
            switch(response.response?.statusCode){
            case 200:
                print("토큰 인증됨.")
            case 401:
                print("토큰 틀림 생성중..")
                self.generationToken()
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
    private func getRandomPeom() {
        Alamofire.request(BASE_URL+"poem/random?date="+today+"&count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
            response in
            guard case let .failure(error) = response.result else {return}
            
            if let error = error as? AFError{
                print(error)
            }
            
            if let random = response.result.value as? [String:Any] {
                print(random["poemId"] as! [String])
            }
        }
    }
    private func getBestPoem(completionHandler: @escaping (_ result: [String:Any]) -> ()) {
    Alamofire.request(BASE_URL+"poem/best?date="+today+"&count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
            response in
            guard case let .failure(error) = response.result else {return}
                
            if let error = error as? AFError{
                print(error)
            }
                
            if let best = response.result.value as? [String:Any] {
                    completionHandler(best)
            }
        }
    }
    
    private func getPoemInfo(){
        Alamofire.request(BASE_URL+"poem?token="+TOKEN+"&poemid=")
    }
}
