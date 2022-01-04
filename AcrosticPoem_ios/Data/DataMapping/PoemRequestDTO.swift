//
//  PoemRequestDTO.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation

struct PoemListReqDTO : Codable {
    
    let token : String
    let wordCount : String
    
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}


struct PoemReqDTO : Codable {
    let token : String
    let wordCount : String
    let poemId : String
    
    private enum CodingKeys : String, CodingKey {
        case token, wordCount, poemId
    }
}
