//
//  Poem.swift
//  Domain
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation

public struct Poems: Codable {
    let title: String
    let poemIDs: [String]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case poemIDs = "peomId"
    }
}

public struct Poem: Codable {
    public let peomID, userID, userName, title: String
    public let like, words: Int
    public let isReported, isLiked: Bool
    public let createdDate: Date
    public let word: [Word]
    
    private enum CodingKeys: String, CodingKey {
        case peomID = "poemId"
        case userID = "userId"
        case isReported = "reported"
        case isLiked = "liked"
        case words = "wordCount"
        case createdDate = "date"
        case userName, title, like, word
    }
}

public struct Word: Codable {
    public let word, line: String
}
