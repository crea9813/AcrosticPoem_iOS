//
//  UICollectionView+Extension.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/24.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit

extension UICollectionView {
    func setEmptyView() {
        let emptyView = UIView()
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "BM YEONSUNG", size: 23)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "BM YEONSUNG", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(emptyView)
            $0.centerY.equalTo(emptyView).offset(-(emptyView.frame.height/8))
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(emptyView)
        }
        
        titleLabel.text = "아직 등록된 시가 없습니다"
        messageLabel.text = "오른쪽 위 추가 버튼으로 첫번째로 시를 등록해보세요"
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
    }
}
