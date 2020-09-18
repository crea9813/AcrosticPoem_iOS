//
//  PoemCell.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/12/10.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit

class PoemCell: UICollectionViewCell {
    
    static let identifier = "PoemCell"
    
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
    public func configure(with model: Poem){
        
        if model.image != ""{
            let url = URL(string: BASE_URL+model.image)
            let data = try! Data(contentsOf: url!)
            
            poemImage.image = UIImage(data: data)
        }else{
            poemImage.image = nil
        }
        
        setTitle(todayTitle: model.title, wordTitle: model.word)
        
    }
    
    private func setTitle(todayTitle : String, wordTitle : [Words]) {
        //삼행시 제목 첫번째 글자 초기화
        titleFirst.font = UIFont(name: "HYgsrB", size: 27)
        titleFirst.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleFirst.text = String(todayTitle[(todayTitle.startIndex)])
        
        //삼행시 제목 두번째 글자 초기화
        titleSecond.font = UIFont(name: "HYgsrB", size: 27)
        titleSecond.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleSecond.text = String(todayTitle[todayTitle.index(todayTitle.startIndex, offsetBy: 1)])
        
        //삼행시 제목 세번째 글자 초기화
        titleThird.font = UIFont(name: "HYgsrB", size: 27)
        titleThird.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleThird.text = String(todayTitle[todayTitle.index(before: todayTitle.endIndex)])
        
        wordFirst.text = String(wordTitle[0].word)
        wordSecond.text = String(wordTitle[1].word)
        wordThird.text = String(wordTitle[2].word)
        wordFirst.adjustsFontSizeToFitWidth = true
        wordSecond.adjustsFontSizeToFitWidth = true
        wordThird.adjustsFontSizeToFitWidth = true
    }

}
