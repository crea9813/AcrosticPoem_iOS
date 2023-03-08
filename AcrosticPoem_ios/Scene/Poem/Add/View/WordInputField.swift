//
//  WordInputField.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import UIKit

class WordInputField : UIView {
    
    let wordView = UILabel().then {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "HYgsrB", size: 27)
        $0.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
        
    }
    
    let textFieldView = UITextField().then {
        $0.backgroundColor = .clear
        $0.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0).cgColor
        $0.layer.cornerRadius = 10
        $0.addLeftPadding()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(wordView)
        self.addSubview(textFieldView)
        
        wordView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().inset(5)
            $0.width.lessThanOrEqualTo(50)
        }
        textFieldView.snp.makeConstraints {
            $0.leading.equalTo(wordView.snp.trailing).offset(10)
            $0.top.bottom.trailing.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
