//
//  AppDelegate.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/05.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigationBarAppearace = UINavigationBar.appearance()
    var uiLabelAppearace = UILabel.appearance()
    
    var titleString : String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 앱 첫 실행인지 판단 후 게스트 토큰 생성 및 검사
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            
            if launchedBefore
            {
                NetworkManager().tokenValidation()
                print("첫 실행이 아님.")
            }
            else
            {
                print("앱 설치 이후 첫 실행 Guest Token 생성 중")
                UserDefaults.standard.set("", forKey: "GuestToken")
                NetworkManager().generationToken()
                UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
        UserDefaults.standard.set("Random", forKey: "Sort")
        
        //네비게이션바 스타일 설정
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.barTintColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HYgsrB", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearace.topItem?.title = ""
        uiLabelAppearace.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        
        return true
    }
    
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

