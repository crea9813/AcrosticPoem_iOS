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
    
    private let BASE_URL = "https://acrosticpoem.azurewebsites.net/"
    private var TOKEN = ""
    
    
    init() {
        TOKEN = UserDefaults.standard.value(forKey: "GuestToken") as! String
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
}
