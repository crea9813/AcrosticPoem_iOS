//
//  PoemModel.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/18.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation

class PoemAddReqModel {
    let token : String
    let image : String
    let 
    
}

class TodayTitle : Codable {
    let title : String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
    }
}

class PoemListGetReqModel {
    let token : String
    let wordCount : String
    
    init(token : String, wordCount : String) {
        self.token = token
        self.wordCount = wordCount
    }
}

class PoemListGetResModel : Codable {
    let title : String?
    let poemId : [String]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        poemId = try? container.decode([String].self, forKey: .poemId)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, poemId
    }
}

class PoemPostReqModel {
    let token : String
    let image : String
    let word : [Word]
    
    init(token : String, image : String, word : [Word]) {
        self.token = token
        self.image = image
        self.word = word
    }
}

class PoemInfoGetReqModel {
    let wordCount : Int
    let token : String
    let poemId : String
    
    init(wordCount : Int, token : String, poemId : String) {
        self.wordCount = wordCount
        self.token = token
        self.poemId = poemId
    }
}

class PoemModel : Codable {
    let wordCount : Int?
    let userName : String?
    let userId : String?
    let poemId : String?
    let like : Int?
    let liked : Bool?
    let reported : Bool?
    let title : String?
    let date : Date?
    let image : String?
    let word : [Word]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        wordCount = try? container.decode(Int.self, forKey: .wordCount)
        userName = try? container.decode(String.self, forKey: .userName)
        userId = try? container.decode(String.self, forKey: .userId)
        poemId = try? container.decode(String.self, forKey: .poemId)
        like = try? container.decode(Int.self, forKey: .like)
        liked = try? container.decode(Bool.self, forKey: .liked)
        reported = try? container.decode(Bool.self, forKey: .reported)
        title = try? container.decode(String.self, forKey: .title)
        date = try? container.decode(Date.self, forKey: .date)
        image = try? container.decode(String.self, forKey: .image)
        word = try? container.decode([Word].self, forKey: .word)
    }
    
    private enum CodingKeys: String, CodingKey {
        case wordCount, userName, userId, poemId, like, liked, reported,title, date, image, word
    }
}

class Word : Codable {
    let word : String?
    let line : String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        word = try? container.decode(String.self, forKey: .word)
        line = try? container.decode(String.self, forKey: .line)
    }
    
    private enum CodingKeys: String, CodingKey {
        case word
        case line
    }
}
