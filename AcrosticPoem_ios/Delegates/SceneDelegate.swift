//
//  SceneDelegate.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/05.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if ( UserDefaults.standard.value(forKey: "launchedBefore") == nil){
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            NetworkService().generationToken()
                .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { token in
                    UserDefaults.standard.set(token, forKey: "token")
                },
                onError: { error in
                    switch error {
                    case ApiError.unAuthorized:
                        print("unAuthorized")
                    case ApiError.internalServerError:
                        print("Server Error")
                    default:
                        print("Unkown Error")
                    }
                }).disposed(by: disposeBag)
        } else {
            NetworkService().tokenValidation(token: UserDefaults.standard.value(forKey: "token") as! String)
                .observeOn(MainScheduler.instance)
            .subscribe(
                onError: { error in
                    switch error {
                    case ApiError.unAuthorized:
                        NetworkService().generationToken()
                            .observeOn(MainScheduler.instance)
                        .subscribe(
                        onNext: { token in
                            UserDefaults.standard.set(token, forKey: "token")
                        },
                        onError: { error in
                            switch error {
                            case ApiError.unAuthorized:
                                print("unAuthorized")
                            case ApiError.internalServerError:
                                print("Server Error")
                            default:
                                print("Unkown Error")
                            }
                        }).disposed(by: self.disposeBag)
                    case ApiError.internalServerError:
                        print("Server Error")
                    default:
                        print("Unknown Error")
                    }
                }).disposed(by: disposeBag)
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
}

