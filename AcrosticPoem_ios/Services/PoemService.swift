//
//  PoemService.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/24.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation

class PoemService : APIService {
    
    static func requestTodayTitle(wordCount : Int, completion: @escaping(Result<String,Error>)->Void) {
        provider.request(.getTodayTitle(wordCount: wordCount), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.data
                do {
                    print("Today Title Response : \(String(data: data, encoding: .utf8)!)")
                    let decoded = try JSONDecoder().decode(String.self, from: data)
                    print("Today Title Response 2 : \(decoded)")
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    static func requestPoemList(reqModel : PoemListGetReqModel, completion: @escaping(Result<PoemListGetResModel, Error>)->Void) {
        provider.request(.getPoemList(reqModel: reqModel), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.data
                do {
                    let decoded = try JSONDecoder().decode(PoemListGetResModel.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    static func requestPoemInfo(reqModel : PoemInfoGetReqModel, completion: @escaping(Result<PoemModel,Error>) -> Void) {
        provider.request(.getPoemInfo(reqModel: reqModel), completion: {
            response in
            switch response {
            case .success(let response):
                let data = response.data
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
    
}
