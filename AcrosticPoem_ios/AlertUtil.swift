//
//  AlertUtil.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/26.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit

class AlertUtil {
    static let shared = AlertUtil()
    
    func showErrorAlert(
        vc : UIViewController,
        title : String?,
        message : String?
        ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(
        vc : UIViewController, title : String?,
        message : String?,
        positiveBtn : String,
        positiveListener : ((UIAlertAction) -> ())? = nil,
        completion : (() -> ())? = nil ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let positiveAction = UIAlertAction(title: positiveBtn, style: .default, handler: positiveListener)
        alert.addAction(positiveAction)
        vc.present(alert, animated: true, completion: completion)
    }
}
