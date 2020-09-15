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
    func tokenValidation(token : String) -> Observable<String> {
        let url = BaseUrl + "guest"
        
        return Observable<String>.create { observer in
            let request = Alamofire.request(url, method: .post, parameters: ["token" : token], encoding: JSONEncoding.default).responseString { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 401: observer.onError(ApiError.unAuthorized)
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
    
    func todayTitle() -> Observable<String>{
        let url = BaseUrl + "title"
        
        return Observable<String>.create { observer in
            let request = Alamofire.request(url, method: .get).responseString {
                response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
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
    
    func submitPoem(poem : PostPoem) -> Observable<String> {
        let url = BaseUrl + "poem"
        return Observable<String>.create { observer in
            let request = Alamofire.request(url,method: .post).responseString { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
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
    
    func getPoem() -> Observable<JSON> {
        let url = BaseUrl + "poem/random/3?count=100"
        return Observable<JSON>.create { observer in
            let request = Alamofire.request(url,method: .get, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value as! JSON)
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
    
    func poemInfo(poemId : String) -> Observable<JSON> {
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let url = BaseUrl + "poem/3?token="+token+"&poemid="+poemId
        return Observable<JSON>.create { observer in
            let request = Alamofire.request(url,method: .get, encoding: JSONEncoding.default,headers: ["Content-Type":"application/json;charset=utf-8"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                observer.onNext(value as! JSON)
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
