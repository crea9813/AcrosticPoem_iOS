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
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "삼행시"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HYgsrB", size: 32)
        label.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                let targetVC = PoemView()
                self.navigationController?.pushViewController(targetVC, animated: true)
            }
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
        
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.00)
        view.addSubview(titleLabel)
        view.addSubview(icon)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view).offset(view.frame.height/3)
            $0.centerX.equalTo(view)
        }
        
        icon.image = UIImage(named: "3")
        
        icon.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.width.equalTo(80)
            $0.height.equalTo(icon.snp.width)
        }
        
        bind()
        login()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.00)
    }
}
