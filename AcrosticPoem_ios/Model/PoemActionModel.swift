//
//  PoemActionModel.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/28.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation

class PoemLikeReqModel {
    let token : String
    let poemId : String
    let wordCount : Int
    
    init(token : String, poemId : String, wordCount : Int) {
        self.token = token
        self.poemId = poemId
        self.wordCount = wordCount
    }
}

class PoemReportReqModel {
    let token : String
    let poemId : String
    let wordCount : Int
    
    init(token : String, poemId : String, wordCount : Int) {
        self.token = token
        self.poemId = poemId
        self.wordCount = wordCount
    }
}
