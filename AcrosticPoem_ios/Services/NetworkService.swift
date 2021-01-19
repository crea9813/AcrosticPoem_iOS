//
//  UserService.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/26.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation
import Moya

class NetworkService : Networkable {
    
    var provider: MoyaProvider<API> = MoyaProvider<API>()
    
     func requestTodayTitle(wordCount : Int, completion: @escaping(Result<String,Error>)->Void) {
        provider.request(.getTodayTitle(wordCount: wordCount), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.data
                    print("Today Title Response : \(String(data: data, encoding: .utf8)!)")
                    completion(.success(String(data: data, encoding: .utf8)!))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
     func requestPoemList(reqModel : PoemListGetReqModel, completion: @escaping(Result<PoemListGetResModel, Error>)->Void) {
        provider.request(.getPoemList(reqModel: reqModel), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.data
                do {
                    let decoded = try JSONDecoder().decode(PoemListGetResModel.self, from: data)
                    completion(.success(decoded))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
     func requestPoemInfo(reqModel : PoemInfoGetReqModel, completion: @escaping(Result<PoemModel,Error>) -> Void) {
        provider.request(.getPoemInfo(reqModel: reqModel), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.data
                print(String(data: data, encoding: .utf8)!)
                do {
                    let decoded = try JSONDecoder().decode(PoemModel.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
     func requestPoemAdd(reqModel : PoemAddReqModel, completion: @escaping(Result<Int,Error>) -> Void) {
        provider.request(.addPoem(reqModel: reqModel), completion: {
            response in
            switch response {
            case .success(let response):
                print(response.statusCode)
                let data = response.statusCode
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
     func requestPoemLike(reqModel : PoemLikeReqModel, completion: @escaping(Result<Int,Error>) -> Void) {
        provider.request(.likePoem(reqModel: reqModel), completion: {
            response in
            switch response {
            case .success(let response):
                print(response.statusCode)
                let data = response.statusCode
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
     func requestPoemReport(reqModel : PoemReportReqModel, completion: @escaping(Result<Int,Error>) -> Void) {
        provider.request(.reportPoem(reqModel: reqModel), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.statusCode
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func requestToken(completion: @escaping(Result<String,Error>)->Void) {
        provider.request(.generationToken(()) , completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.data
                    print("Token Response : \(String(data: data, encoding: .utf8)!)")
                    completion(.success(String(data: data, encoding: .utf8)!))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func validateToken(token : String, completion: @escaping(Result<Int,Error>)->()) {
        provider.request(.validationToken(token: token), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.statusCode
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
