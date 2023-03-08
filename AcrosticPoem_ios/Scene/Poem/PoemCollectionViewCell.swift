//
//  PoemCollectionViewCell.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/03.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import Foundation
import UIKit

class PoemCollectionViewCell: UICollectionViewCell {
    
    private let actionView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white.withAlphaComponent(0.8)
    }
    
    private let likeButton = UIButton().then {
        $0.setTitle("12", for: .normal)
        $0.setImage(UIImage(named: "ic_like_inactive"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        $0.tintColor = UIColor(hex: "9E9E9E")
        $0.setTitleColor(UIColor(hex: "9E9E9E"), for: .normal)
        $0.backgroundColor = .clear
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    }
    
    public func bind(with viewModel: PoemItemViewModel) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 26
        
        self.addSubview(actionView)
        actionView.addSubview(likeButton)
        
        actionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
