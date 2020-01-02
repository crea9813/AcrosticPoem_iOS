//
//  PoemAddViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/15.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import Alamofire

class PoemAddViewController: UIViewController {
    
    let ad = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    @IBOutlet var TextTitleFirst: UILabel!
    @IBOutlet var TextTitleSecond: UILabel!
    @IBOutlet var TextTitleThird: UILabel!
    
    @IBOutlet var TextFirst: UITextField!
    @IBOutlet var TextSecond: UITextField!
    @IBOutlet var TextThird: UITextField!
    
    @IBOutlet var importImage: UIImageView!
    
    @IBOutlet var submitPoemButton: UIBarButtonItem!
    
    var PoemInfo : PoemPostModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupView(todayTitle: ad!.titleString!)
        
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
           let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
           return strBase64
    }

    
    @IBAction func submitPoemAction(_ sender: Any) {
        let imageUrl = convertImageToBase64(importImage.image!)
        
        PoemInfo = PoemPostModel(token: UserDefaults.standard.value(forKey: "GuestToken") as! String, Image: imageUrl, word: [Word(word: titleFirst.text!, line: TextFirst.text!),Word(word: titleSecond.text!, line: TextSecond.text!),Word(word:  titleThird.text!, line: TextThird.text!)])
        
//        DispatchQueue.global().sync {
//            NetworkManager().submitPoem(postPoemModel: PoemInfo!)
//        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupView(todayTitle : String) {
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        
        //폰트 초기화
        titleFirst.font = UIFont(name: "HYgsrB", size: 27)
        titleSecond.font = UIFont(name: "HYgsrB", size: 27)
        titleThird.font = UIFont(name: "HYgsrB", size: 27)
        TextTitleFirst.font = UIFont(name: "HYgsrB", size: 27)
        TextTitleSecond.font = UIFont(name: "HYgsrB", size: 27)
        TextTitleThird.font = UIFont(name: "HYgsrB", size: 27)
        
        // 글 색상 초기화
        titleFirst.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleSecond.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        titleThird.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        TextTitleFirst.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        TextTitleSecond.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        TextTitleThird.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        
        //단어 초기화
        titleFirst.text = String(todayTitle[(todayTitle.startIndex)])
        titleSecond.text = String(todayTitle[todayTitle.index(todayTitle.startIndex, offsetBy: 1)])
        titleThird.text = String(todayTitle[todayTitle.index(before: todayTitle.endIndex)])
        TextTitleFirst.text = titleFirst.text
        TextTitleSecond.text = titleSecond.text
        TextTitleThird.text = titleThird.text
        
    }
    
}
