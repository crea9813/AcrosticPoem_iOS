//
//  LabelTextSpacing.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/09/18.
//  Copyright © 2020 Minestrone. All rights reserved.
//
import UIKit

extension UILabel {
    // adding space between each characters
    func addCharacterSpacing(kernValue: Double = 3) {
        if let labelText = text,
            labelText.isEmpty == false {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.kern,
                                          value: kernValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
