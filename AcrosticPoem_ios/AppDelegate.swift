//
//  AppDelegate.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/05.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigationBarAppearace = UINavigationBar.appearance()
    var uiLabelAppearace = UILabel.appearance()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
        }
        else
        {
            print("First launch")
            Alamofire.request("https://acrosticpoem.azurewebsites.net/guest", method: .get).responseString {
                response in
                switch(response.result){
                case .success(_):
                    if let guestToken = response.result.value{
                        UserDefaults.standard.set(guestToken, forKey: "GuestToken")
                    }
                case .failure(_):
                    print(response.result.error!)
                }
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        // Override point for customization after application launch.
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.barTintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HYgsrB", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearace.topItem?.title = ""
        uiLabelAppearace.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

