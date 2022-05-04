//
//  API.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/18.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Moya

enum API {
    case getPoemInfo(type: Int, id: String)
    case getPoemList(type : PoemType)
    case getTodayTitle(wordCount : Int)
    case generationToken(Void)
    case validationToken(token : String)
//    case likePoem(reqModel : PoemLikeReqModel)
//    case reportPoem(reqModel : PoemReportReqModel)
    case addPoem(reqModel : PoemAddReqDTO)
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
        case .getPoemInfo:
            return "/poem"
        case .getPoemList:
            return "/poem/random"
        case .getTodayTitle(let wordCount):
            return "/title/"+String(wordCount)
        case .generationToken:
            return "/guest"
        case .validationToken:
            return "/guest"
//        case .likePoem(let reqModel):
//            return "/poem/like/"+String(reqModel.wordCount)
//        case .reportPoem(let reqModel):
//            return "/poem/report/"+String(reqModel.wordCount)
        case .addPoem(let reqModel):
            return "/poem/"+reqModel.wordCount
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
//        case .likePoem:
//            return .post
//        case .reportPoem:
//            return .post
        case .addPoem:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .getPoemInfo(type, id):
            return .requestParameters(parameters: [
                "" : type,
                "token" : Constant.shared.token,
                "poemId" : id
            ], encoding: URLEncoding.default)
        case let .getPoemList(type):
            return .requestParameters(parameters: [
                "" : type.rawValue,
                "count" : 100
            ], encoding: URLEncoding.default)
        case .getTodayTitle:
            return .requestPlain
        case .generationToken:
            return .requestPlain
        case .validationToken(let token):
            return .requestParameters(parameters: [
                "token" : token
            ], encoding: JSONEncoding.default)
//        case .likePoem(let reqModel):
//            return .requestParameters(parameters: [
//                "token" : reqModel.token,
//                "poemid" : reqModel.poemId
//            ], encoding: JSONEncoding.default)
//        case .reportPoem(let reqModel):
//            return .requestParameters(parameters: [
//                "token" : reqModel.token,
//                "poemId" : reqModel.poemId
//            ], encoding: JSONEncoding.default)
        case .addPoem(let reqModel):
            return .requestParameters(parameters: [
                "token" : "123123123",
                "image" : reqModel.image,
                "word" :
                [
                    [ "word" : reqModel.word[0].word, "line" : reqModel.word[0].line ],
                    [ "word" : reqModel.word[1].word, "line" : reqModel.word[1].line],
                    [ "word" : reqModel.word[2].word, "line" : reqModel.word[2].line ]
                ]
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
