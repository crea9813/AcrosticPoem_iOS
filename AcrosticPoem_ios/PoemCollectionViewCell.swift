//
//  PoemCollectionViewCell.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/09/16.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit

class PoemCollectionViewCell : UICollectionViewCell {
    static let identifier = "PoemCollectionViewCell"
    
    let titleFirst : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let titleSecond : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let titleThird : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let wordFirst : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let wordSecond : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let wordThird : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "pencil.and.outline")!
        
        imageView.image = image
        imageView.tintColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.addSubview(titleFirst)
        self.addSubview(titleSecond)
        self.addSubview(titleThird)
        self.addSubview(wordFirst)
        self.addSubview(wordSecond)
        self.addSubview(wordThird)
        self.addSubview(imageView)
    }
    
    private func addViews() {
        
    }
    
    
    
}
