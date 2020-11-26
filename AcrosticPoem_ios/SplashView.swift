//
//  SplashView.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/26.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit
import RxSwift

class SplashView : UIViewController {
    
    let icon = UIImageView()
    
    let viewModel = SplashViewModel()
    
    let disposeBag = DisposeBag()
    
    private func bind() {
        viewModel.errorMessage.subscribe(onNext: {
            error in
            self.showRestartAlert(message: error)
        }).disposed(by: disposeBag)
        
        viewModel.tokenSuccess.subscribe(onNext: {
            token in
            Constant.shared.token = token
        }).disposed(by: disposeBag)
        
        viewModel.validateSuccess.subscribe(onNext: {
            code in
            let targetVC = PoemView()
            self.navigationController?.pushViewController(targetVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func showRestartAlert(message : String){
        AlertUtil.shared.showAlert(vc: self, title: "로그인 오류", message: message, positiveBtn: "재시작", positiveListener: { action in
            self.restartApplication()
            // applicastion finish
        }, completion: nil)
    }
    private func restartApplication () {
        let viewController = SplashView()
        let navCtrl = UINavigationController(rootViewController: viewController)

        guard
            let window = UIApplication.shared.windows.first,
                let rootViewController = window.rootViewController
                else {
            return
        }

        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()

        window.rootViewController = navCtrl
    }
    
    private func login() {
        if Constant.shared.token.isEmpty {
            viewModel.requestToken()
        } else {
            viewModel.validateToken(token: Constant.shared.token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.65, green: 0.59, blue: 0.57, alpha: 1.00)
        
        view.addSubview(icon)
        
        icon.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        bind()
        login()
    }
}
