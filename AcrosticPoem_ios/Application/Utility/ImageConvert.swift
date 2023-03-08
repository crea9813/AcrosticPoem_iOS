//
//  ImageConvert.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/09/18.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit

extension UIViewController {
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
           let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
           return strBase64
    }
}
