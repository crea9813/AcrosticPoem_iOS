//
//  PoemResponseDTO.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation

struct PoemListResDTO: Decodable {
    
    let title : String
    let poemID : [String]
    
    private enum CodingKeys: String, CodingKey {
        case title, poemID
    }
}

extension PoemListResDTO {
    func toDomain() -> Poems {
        return .init(title: title, poemID: poemID)
    }
}

struct PoemResDTO : Decodable {
    let wordCount : Int
    let userName : String
    let userId : String
    let poemId : String
    let like : Int
    let liked : Bool
    let reported : Bool
    let title : String
    let date : Date
    let image : String
    let word : [Word]
    
    private enum CodingKeys: String, CodingKey {
        case wordCount, userName, userId, poemId, like, liked, reported,title, date, image, word
    }
}


struct WordDTO : Codable {
    let word : String
    let line : String
    
    private enum CodingKeys: String, CodingKey {
        case word, line
    }
}

extension PoemResDTO {
    func toDomain() -> PoemModel {
        return .init(wordCount: wordCount, userName: userName, userId: userId, poemId: poemId, like: like, liked: liked, reported: reported, title: title, date: date, image: image, word: word)
    }
}

extension WordDTO {
    func toDomain() -> Word {
        return .init(word: word, line: line)
    }
}
