//
//  Poem.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/09/15.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import Foundation

struct Poem {
    let wordCount : Int
    let userName : String
    let userId : String
    let poemId : String
    let like : Int
    let liked : Bool
    let reported : Bool
    let title : String
    let date : String
    let image : String
    let word : [Words]
}

struct PostPoem {
    let token : String
    let image : String
    let word : [Words]
}

struct Words {
    let word : String
    let line : String
}
