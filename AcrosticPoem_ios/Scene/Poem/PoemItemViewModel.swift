//
//  PoemItemViewModel.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation
import Domain

struct PoemItemViewModel {
    
    let title: String
    let isLiked: Bool
    let words: [String]
    let wordCount, like: Int
    
    let poem: Poem
    
    init(poem: Poem) {
        self.poem = poem
        
        self.title = poem.title
        self.isLiked = poem.isLiked
        self.words = poem.word.map { $0.word }
        self.wordCount = poem.words
        self.like = poem.like
    }
}
