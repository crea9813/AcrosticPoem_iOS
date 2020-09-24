//
//  NetworkService.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/09/13.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import SwiftyJSON

enum ApiError: Error {
    case unAuthorized           //Status code 401
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

class NetworkService {
    private let BaseUrl = "http://149.28.22.157:4567/"
    
    func generationToken() -> Observable<String> {
        let url = BaseUrl + "guest"
        return Observable<String>.create { observer in
            let request = Alamofire.request(url, method: .get).responseString {
                response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    UserDefaults.standard.set(value, forKey: "token")
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403: observer.onError(ApiError.forbidden)
                    case 500: observer.onError(ApiError.internalServerError)
                    default : observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    func tokenValidation(token : String) -> Observable<Void> {
        let url = BaseUrl + "guest"
        
        return Observable<Void>.create { observer in
            let request = Alamofire.request(url, method: .post, parameters: ["token": token], encoding: JSONEncoding.default).response { response in
                switch response.response?.statusCode {
                case 200: observer.onCompleted()
                case 401: observer.onError(ApiError.unAuthorized)
                case 500: observer.onError(ApiError.internalServerError)
                default: observer.onError(response.error!)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func todayTitle() -> Observable<[String:String]>{
        let url = BaseUrl + "title"
        
        return Observable<[String:String]>.create { observer in
            let request = Alamofire.request(url, method: .get).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value as! [String:String])
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 401:
                        observer.onError(ApiError.unAuthorized)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create{
                request.cancel()
            }
        }
    }
    
    func submitPoem(poem : PostPoem) -> Observable<Void> {
        let url = BaseUrl + "poem/3"
        let word = poem.word
        let parameters = [
            "token" : poem.token,
            "image" : poem.image,
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
        
        return Observable<Void>.create { observer in
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                switch response.response?.statusCode {
                case 200: observer.onCompleted()
                case 401: observer.onError(ApiError.unAuthorized)
                case 500: observer.onError(ApiError.internalServerError)
                default: observer.onError(ApiError.conflict)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func getPoem() -> Observable<[String]> {
        let url = BaseUrl + "poem/random/3?count=100"
        
        var list:[String] = []
        return Observable<[String]>.create { observer in
            let request = Alamofire.request(url,method: .get, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let data = value as? [String:Any] {
                        if data["poemId"] == nil {
                            observer.onCompleted()
                        }else {
                            list = data["poemId"] as! [String]
                            observer.onNext(list)
                            observer.onCompleted()
                        }
                    }
                   
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 401: observer.onError(ApiError.unAuthorized)
                    case 500: observer.onError(ApiError.internalServerError)
                    default: observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func poemInfo(poemId : String) -> Observable<Poem> {
        let decoder = JSONDecoder()
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let url = BaseUrl + "poem/3?token="+token+"&poemid="+poemId
        return Observable<Poem>.create { observer in
            let request = Alamofire.request(url,method: .get, encoding: JSONEncoding.default,headers: ["Content-Type":"application/json;charset=utf-8"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let info = try decoder.decode(Poem.self, from: jsonData)
                        
                        observer.onNext(info)
                    } catch {
                        print(error.localizedDescription)
                    }
                    observer.onCompleted()
                
            case .failure(let error):
                switch response.response?.statusCode {
                case 401: observer.onError(ApiError.unAuthorized)
                case 500: observer.onError(ApiError.internalServerError)
                default: observer.onError(error)
                }
            }
        }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func likePoem(poemId : String) -> Observable<Void> {
        let url = BaseUrl+"poem/like/3"
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let parameters = ["token" : token, "poemId" : poemId]
        return Observable<Void>.create { observer in
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                switch response.response?.statusCode {
                case 200: observer.onCompleted()
                case 401: observer.onError(ApiError.unAuthorized)
                case 500: observer.onError(ApiError.internalServerError)
                default: observer.onError(response.error!)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func reportPoem(poemId : String) -> Observable<Void> {
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let url = BaseUrl+"poem/report/3"
        let parameters = ["token" : token, "poemId" : poemId]
        
        return Observable<Void>.create { observer in
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                switch response.response?.statusCode {
                    case 200: observer.onCompleted()
                    case 401: observer.onError(ApiError.unAuthorized)
                    case 500: observer.onError(ApiError.internalServerError)
                    default: observer.onError(response.error!)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
