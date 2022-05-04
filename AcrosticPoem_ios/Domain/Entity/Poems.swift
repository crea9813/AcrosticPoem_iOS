//
//  PoemEntity.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation

struct Poems: Equatable {
    let title: String
    let poemID: [String]
}

public class PoemListItemModel : Codable {
    let title : String?
    let poemId : [String]?
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        poemId = try? container.decode([String].self, forKey: .poemId)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, poemId
    }
}

struct PoemModel : Codable {
    let wordCount : Int
    let userName : String
    let userId : String
    let poemId : String
    let like : Int
    let liked : Bool
    let reported : Bool
    let title : String
    let date : Date
    let image : String?
    let word : [Word]
}

struct Word : Codable {
    let word : String
    let line : String
}
