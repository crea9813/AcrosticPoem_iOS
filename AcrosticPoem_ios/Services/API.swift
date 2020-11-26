//
//  API.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/18.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Moya

enum API {
    case getPoemInfo(reqModel : PoemInfoGetReqModel)
    case getPoemList(reqModel : PoemListGetReqModel)
    case getTodayTitle(wordCount : Int)
    case generationToken(Void)
    case validationToken(token : String)
}

extension API: TargetType {
    var sampleData: Data {
        return .init()
    }
    
    var baseURL: URL {
        return URL(string: "http://149.28.22.157:4567")!
    }
    
    var path: String {
        switch self {
        case .getPoemInfo(let reqModel):
            return "/poem/"+String(reqModel.wordCount)+"?token="+reqModel.token+"&poemId="+reqModel.poemId
        case .getPoemList(let reqModel):
            return "/poem/random/"+reqModel.wordCount+"?count=100"
        case .getTodayTitle(let wordCount):
            return "/title/"+String(wordCount)
        case .generationToken:
            return "/guest"
        case .validationToken:
            return "/guest"
        }
    }
    var method: Method {
        switch self {
        case .getPoemInfo:
            return .get
        case .getPoemList:
            return .get
        case .getTodayTitle:
            return .get
        case .generationToken:
            return .get
        case .validationToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPoemInfo:
            return .requestPlain
        case .getPoemList:
            return .requestPlain
        case .getTodayTitle:
            return .requestPlain
        case .generationToken:
            return .requestPlain
        case .validationToken(let token):
            return .requestParameters(parameters: [
                "token" : token
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
