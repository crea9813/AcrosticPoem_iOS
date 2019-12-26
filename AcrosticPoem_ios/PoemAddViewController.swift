//
//  PoemAddViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/15.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import Alamofire

class PoemAddViewController: UIViewController{
    private var titleString: String?
    
    @IBOutlet var titleFirst: UILabel!
    @IBOutlet var titleSecond: UILabel!
    @IBOutlet var titleThird: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        
    }
    
}
