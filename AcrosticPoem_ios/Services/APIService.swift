//
//  APIService.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/24.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation
import Moya

class APIService {
    static let provider = MoyaProvider<API>()
}

protocol Networkable {
    var provider : MoyaProvider<API> { get }
    
    func requestToken(completion: @escaping(Result<String,Error>)->Void)
    
    func validateToken(token : String, completion: @escaping(Result<Int,Error>)->())
    
    func requestTodayTitle(wordCount : Int, completion: @escaping(Result<String,Error>)->Void)
    
    func requestPoemList(reqModel : PoemListGetReqModel, completion: @escaping(Result<PoemListGetResModel, Error>)->Void)
    
    func requestPoemInfo(reqModel : PoemInfoGetReqModel, completion: @escaping(Result<PoemModel,Error>) -> Void)
    
    func requestPoemAdd(reqModel : PoemAddReqModel, completion: @escaping(Result<Int,Error>) -> Void)
    
    func requestPoemLike(reqModel : PoemLikeReqModel, completion: @escaping(Result<Int,Error>) -> Void)
    
    func requestPoemReport(reqModel : PoemReportReqModel, completion: @escaping(Result<Int,Error>) -> Void)
}
