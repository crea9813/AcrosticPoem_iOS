//
//  NetworkManager.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/25.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager {

    private let BASE_URL:String
    private var TOKEN:String = ""
    private var count:String
    private let sort:Bool
    private var poemList:Array<String> = []
    
    public var imageArr = [String]()
    var wordArr = [NSArray]()
    var likeArr = [Int]()
    
    
    init() {
        BASE_URL = "http://149.28.22.157:4568/"
        count = "10"
        sort = true
        TOKEN = UserDefaults.standard.value(forKey: "GuestToken") as! String
    }
      
    public func getPoemList() -> Int{
        return poemList.count
    }
    // 토큰 생성
    public func generationToken() {
        Alamofire.request("http://149.28.22.157:4568/guest", method: .get).responseString {
            response in
            switch(response.result){
            case .success(_):
                if let guestToken = response.result.value{
                    UserDefaults.standard.set(guestToken, forKey: "GuestToken")
                }
            case .failure(_):
                print("토큰 생성 실패: ",response.result.error!)
            }
        }
    }
    // 앱 첫 실행 or 첫 실행 이후 토큰 검사
    
    // 토큰 유효성 검사
    public func tokenValidation() {
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
        Alamofire.request(BASE_URL+"title/3", method: .get).responseString {
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
    public func submitPoem(postPoemModel : PoemPostModel){
        let word = postPoemModel.word
        let parameters = [
            "token" : postPoemModel.token,
            "image" : postPoemModel.Image,
            "word" : [[
                    "word" : word[0].word,
                    "line" : word[0].line
                ],
                [
                    "word" : word[1].word,
                    "line" : word[1].line
                ],
                [
                    "word" : word[2].word,
                    "line" : word[2].line
                ]
            ]
            ] as [String : Any]
        
        Alamofire.request(BASE_URL+"poem/"+"3", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString {
            response in
            switch(response.response?.statusCode){
            case 200:
                print("삼행시 제출 성공")
            case 401:
                print("토큰 틀림")
            default:
                break;
            }
        }
    }
    
    //랜덤 시 가져오기
    public func getRandomPeom(completionHandler: @escaping (_ result: [String:Any]) -> ()) {
        Alamofire.request(BASE_URL+"poem/random/3?count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
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
                print("랜덤 시 불러오기 실패",result.result.error!)
            }
        }
    }
    
    //추천 시 가져오기
    public func getBestPoem(completionHandler: @escaping (_ result: [String:Any]) -> ()) {
        Alamofire.request(BASE_URL+"poem/best/3?count="+count, method: .get, encoding: JSONEncoding.default).responseJSON {
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
    public func getPoemInfo(poemId : String, completionHandler: @escaping (_ result: JSON) -> ()){
        Alamofire.request(BASE_URL+"poem/3?token="+TOKEN+"&poemid="+poemId, method: .get, encoding: JSONEncoding.default , headers:  ["Content-Type":"application/json;charset=utf-8"] ).responseJSON {
            response in
            switch(response.result){
            case .success(_):
                    if let poemData = try? JSONSerialization.data(withJSONObject: response.result.value!, options: .prettyPrinted){
                        let poemInfo = try? JSON(data: poemData)
                        completionHandler(poemInfo!)
                    }
//                if let poemInfo = response.result.value as? NSDictionary{
//                    self.imageArr.append(poemInfo["image"] as! String)
//                    self.wordArr.append(poemInfo["word"] as! NSArray)
//                    print(self.imageArr,self.wordArr)
//                }
            case .failure(_):
                print("시 정보 불러오기 실패",response.result.error!)
            }
        }
    }
    
//    public func getPoemInfo(poemId : String, completion: @escaping ([PoemData]) -> ()) {
//        Alamofire.request(BASE_URL+"poem/3?token="+TOKEN+"&poemid="+poemId, method: .get, encoding: JSONEncoding.default).responseJSON{
//            (response) in
//            guard let data = response.data else {return}
//            do{
//                let poems = try JSONDecoder().decode([PoemData].self, from:data)
//            }catch{
//                print(error.localizedDescription)
//            }
//        }
//
//    }
    //랜덤으로 가져올지 인기순으로 가져올지
    public func poemSort(){
        var poem:Array<String> = []
        
        switch(sort){
        case true:
            getRandomPeom{
                result in
                poem = result["poemId"] as! [String]
                for count in 0..<poem.count {
                    self.getPoemInfo(poemId: poem[count]){
                        result in
                        
                    }
                }
            }
        case false:
            getBestPoem{
                result in
                poem = result["poemId"] as! [String]
                for count in 0..<poem.count {
                    self.getPoemInfo(poemId: poem[count]){
                        result in
                        
                    }
                }
            }
        }
    }
    //시 좋아요
    public func likePoem(poemId : String){
        Alamofire.request(BASE_URL+"poem/like/3", method: .post, parameters: ["token" : TOKEN, "poemId" : poemId], encoding: JSONEncoding.default).responseJSON{
            response in
            switch(response.response?.statusCode){
            case 200:
                print("좋아요 성공")
            case 401:
                print("토큰 틀림")
            case 404:
                print("삼행시 없음")
            default:
                break
            }
        }
    }
    //시 신고하기
    public func reportPoem(poemId : String){
        Alamofire.request(BASE_URL+"poem/report/3", method: .post, parameters: ["token" : TOKEN, "poemId" : poemId], encoding: JSONEncoding.default).responseJSON{
            response in
            switch(response.response?.statusCode){
            case 200:
                print("신고 제출 성공")
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
