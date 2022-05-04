//
//  PoemRequestDTO.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation

struct PoemListRequestModel : Codable {
    let wordCount : String
}


struct PoemReqDTO : Codable {
    let token : String
    let wordCount : String
    let poemId : String
    
    private enum CodingKeys : String, CodingKey {
        case token, wordCount, poemId
    }
}
