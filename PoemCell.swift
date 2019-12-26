//
//  PoemCell.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/12/10.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit

struct PoemModel {
    let titleFirst : String
    let titleSecond : String
    let titleThird : String
    let wordFirst : String
    let wordSecond : String
    let wordThird : String
}

class PoemCell: UICollectionViewCell {

    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    @IBOutlet var wordFirst: UILabel!
    @IBOutlet var wordSecond: UILabel!
    @IBOutlet var wordThird: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func configure(with model: PoemModel){
        titleFirst.text = model.titleFirst
        titleSecond.text = model.titleSecond
        titleThird.text = model.titleThird
        wordFirst.text = model.wordFirst
        wordSecond.text = model.wordSecond
        wordThird.text = model.wordThird
        
    }

}
