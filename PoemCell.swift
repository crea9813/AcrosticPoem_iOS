//
//  PoemCell.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/12/10.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit

class PoemCell: UICollectionViewCell {
    
    @IBOutlet var poemImage: UIImageView!
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    @IBOutlet var wordFirst: UILabel!
    @IBOutlet var wordSecond: UILabel!
    @IBOutlet var wordThird: UILabel!
    
    let BASE_URL = "http://149.28.22.157:4567/"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    // PoemModel로 Cell의 내용을 초기화
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
