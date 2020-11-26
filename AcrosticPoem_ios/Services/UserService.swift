//
//  UserService.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/26.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation

class UserService : APIService{
    
    static func requestToken(completion: @escaping(Result<String,Error>)->Void) {
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
    
    static func validateToken(token : String, completion: @escaping(Result<Int,Error>)->()) {
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
