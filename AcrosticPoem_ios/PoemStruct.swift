//
//  PoemStruct.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/01/07.
//  Copyright © 2020 Minestrone. All rights reserved.
//

struct PoemModel {
    let imageUrl : String
    let titleFirst : String
    let titleSecond : String
    let titleThird : String
    let wordFirst : String
    let wordSecond : String
    let wordThird : String
    let poemId : String
    let reported : Bool
    let like : String
    let liked : Bool
}

struct PoemPostModel {
    let token : String
    let Image : String
    let word : [Word]
}

struct Word {
    let word : String
    let line : String
}


