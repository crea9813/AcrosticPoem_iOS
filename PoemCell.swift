//
//  PoemCell.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/12/10.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit

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

class PoemCell: UICollectionViewCell {
    
    @IBOutlet var poemImage: UIImageView!
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    @IBOutlet var wordFirst: UILabel!
    @IBOutlet var wordSecond: UILabel!
    @IBOutlet var wordThird: UILabel!
    
    let BASE_URL = "http://149.28.22.157:4568/"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func configure(with model: PoemModel){
        if model.imageUrl != ""{
            let url = URL(string: BASE_URL+model.imageUrl)
            let data = try! Data(contentsOf: url!)
            
            poemImage.image = UIImage(data: data)
        }else{
            poemImage.image = nil
        }
        
        titleFirst.text = model.titleFirst
        titleSecond.text = model.titleSecond
        titleThird.text = model.titleThird
        wordFirst.text = model.wordFirst
        wordSecond.text = model.wordSecond
        wordThird.text = model.wordThird
        
    }

}
