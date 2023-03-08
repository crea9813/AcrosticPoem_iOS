//
//  PoemCell.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/27.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

protocol PoemCellAction: AnyObject {
    func didLikeButtonClicked(with id: String)
    func didReportButtonClicked(with id: String)
}

class PoemCell: UICollectionViewCell {
    static let identifier = "PoemCell"
    
    weak var action: PoemCellAction?
    
    let poemFirst = UILabel()
    let poemSecond = UILabel()
    let poemThird = UILabel()
    let poemImage = UIImageView()
    
    let likeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.setImage(UIImage(named: "heart_fill"), for: .selected)
        return button
    }()
    let shareButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setImage(UIImage(named: "share_fill"), for: .selected)
        return button
    }()
    let reportButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "report"), for: .normal)
        return button
    }()
    
    let likeCount = UILabel()
    
    // PoemModel로 Cell의 내용을 초기화
    public func configure(with model: PoemModel){
        if let imageURL = model.image, let url = URL(string: "http://149.28.22.157:4567/\(imageURL)") {
            let data = try! Data(contentsOf: url)
            poemImage.isHidden = false
            poemImage.image = UIImage(data: data)
        } else { poemImage.isHidden = true }
        
        likeButton.isSelected = model.liked
        likeCount.text = "\(model.like)"
        poemFirst.text = "\(model.word[0].word) : \(model.word[0].line)"
        poemSecond.text = "\(model.word[1].word) : \(model.word[1].line)"
        poemThird.text = "\(model.word[2].word) : \(model.word[2].line)"
        
        
        if model.word[0].line.count >= 16 {
            let attributedStr = NSMutableAttributedString(string: poemFirst.text!)
            
            attributedStr.addAttribute(.font, value: UIFont(name: "HYgsrB", size: CGFloat(40-model.word[1].line.count))!, range: (poemFirst.text! as NSString).range(of: model.word[0].line ))
            poemFirst.attributedText = attributedStr
        }
        if model.word[1].line.count >= 16 {
            let attributedStr = NSMutableAttributedString(string: poemSecond.text!)
            
            attributedStr.addAttribute(.font, value: UIFont(name: "HYgsrB", size: CGFloat(40-model.word[1].line.count))!, range: (poemSecond.text! as NSString).range(of: model.word[1].line ))
            poemSecond.attributedText = attributedStr
        }
        if model.word[2].line.count >= 16 {
            let attributedStr = NSMutableAttributedString(string: poemThird.text!)
            
            attributedStr.addAttribute(.font, value: UIFont(name: "HYgsrB", size: CGFloat(40-model.word[2].line.count))!, range: (poemThird.text! as NSString).range(of: model.word[2].line ))
            poemThird.attributedText = attributedStr
        }
    }
    
    private func setupView() {
        self.addSubview(poemImage)
        self.addSubview(poemFirst)
        self.addSubview(poemSecond)
        self.addSubview(poemThird)
        self.addSubview(likeButton)
        self.addSubview(shareButton)
        self.addSubview(reportButton)
        self.addSubview(likeCount)
        
        poemFirst.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.leading.trailing.equalTo(poemThird)
            $0.top.equalTo(self).offset(20)
        }
        poemSecond.snp.makeConstraints{
            $0.top.equalTo(poemFirst.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(poemFirst)
            $0.centerX.equalTo(self)
        }
        poemThird.snp.makeConstraints {
            $0.top.equalTo(poemSecond.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(poemSecond)
            $0.centerX.equalTo(self)
        }
        poemImage.snp.makeConstraints {
            $0.top.equalTo(poemThird.snp.bottom).offset(30)
            $0.leading.equalTo(self).offset(20)
            $0.trailing.equalTo(self).inset(20)
            $0.height.equalTo(poemImage.snp.width).multipliedBy(0.6)
        }
        likeButton.snp.makeConstraints {
            $0.top.equalTo(poemImage.snp.bottom).offset(15)
            $0.leading.equalTo(self).offset(30)
            $0.width.height.equalTo(25)
        }
        likeCount.snp.makeConstraints {
            $0.top.equalTo(likeButton)
            $0.leading.equalTo(likeButton.snp.trailing).offset(10)
        }
        reportButton.snp.makeConstraints {
            $0.top.equalTo(likeButton)
            $0.trailing.equalTo(self).inset(30)
            $0.width.height.equalTo(25)
        }
        shareButton.snp.makeConstraints {
            $0.top.equalTo(likeButton)
            $0.trailing.equalTo(self).inset(70)
            $0.width.height.equalTo(25)
        }
        
        poemImage.contentMode = .scaleAspectFill
        poemImage.clipsToBounds = true
        poemImage.layer.cornerRadius = 10
        
        poemFirst.textAlignment = .left
        poemSecond.textAlignment = .left
        poemThird.textAlignment = .left
        
        poemFirst.font = UIFont(name: "HYgsrB", size: 25)
        poemSecond.font = UIFont(name: "HYgsrB", size: 25)
        poemThird.font = UIFont(name: "HYgsrB", size: 25)
        likeCount.font = UIFont.systemFont(ofSize: 20)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        poemImage.image = nil
    }

}
