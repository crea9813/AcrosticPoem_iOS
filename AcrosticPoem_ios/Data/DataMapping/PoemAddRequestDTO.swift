//
//  PoemAddRequestDTO.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import Foundation

struct PoemAddReqDTO : Codable {
    
    let image : String
    let word : [Word]
    let wordCount : String
    
    private enum CodingKeys : String, CodingKey {
        case image, word, wordCount
    }
}
