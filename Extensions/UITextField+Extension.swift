//
//  UITextField+Extension.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/29.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
