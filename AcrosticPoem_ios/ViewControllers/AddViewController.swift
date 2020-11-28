//
//  AddViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2020/09/16.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit
import RxSwift

class AddViewController : UIViewController {
    
    let picker = UIImagePickerController()
    
    private var imagePick = false
    
    let disposeBag = DisposeBag()
    
    let titleImage : UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "title3")
        
        return imageView
    }()
    
    let todayTitle : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    let addView : UIView = {
        let addView = UIView()
        addView.backgroundColor = .none
        return addView
    }()
    
    let wordTitleFirst : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    let wordTitleSecond : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    let wordTitleThird : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    let textFieldFirst : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "최대 30자",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.layer.borderWidth = 1.0
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let textFieldSecond : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "최대 30자",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.layer.borderWidth = 1.0
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let textFieldThird : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "최대 30자",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.layer.borderWidth = 1.0
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let uploadImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add_image")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(titleImage)
        titleImage.addSubview(todayTitle)
        view.addSubview(addView)
        addView.addSubview(wordTitleFirst)
        addView.addSubview(wordTitleSecond)
        addView.addSubview(wordTitleThird)
        addView.addSubview(textFieldFirst)
        addView.addSubview(textFieldSecond)
        addView.addSubview(textFieldThird)
        addView.addSubview(uploadImageView)
        
        titleImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(37)
            $0.height.equalTo(view.frame.height/7)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        todayTitle.snp.makeConstraints {
            $0.centerX.centerY.equalTo(titleImage)
        }
        addView.snp.makeConstraints {
            $0.top.equalTo(titleImage.snp.bottom)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        todayTitle.addCharacterSpacing(kernValue: 30)
        wordTitleFirst.snp.makeConstraints {
            $0.left.equalTo(addView).offset(22)
            $0.top.equalTo(addView).offset(28)
            $0.width.lessThanOrEqualTo(60)
        }
        wordTitleSecond.snp.makeConstraints {
            $0.left.equalTo(addView).offset(22)
            $0.top.equalTo(wordTitleFirst.snp.bottom).offset(28)
            $0.width.equalTo(wordTitleFirst)
        }
        wordTitleThird.snp.makeConstraints {
            $0.left.equalTo(addView).offset(22)
            $0.top.equalTo(wordTitleSecond.snp.bottom).offset(28)
            $0.width.equalTo(wordTitleFirst)
        }
        textFieldFirst.snp.makeConstraints {
            $0.left.equalTo(wordTitleFirst.snp.right).offset(8)
            $0.top.equalTo(addView).offset(28)
            $0.right.equalTo(addView).inset(22)
            $0.height.equalTo(wordTitleFirst.snp.height)
        }
        textFieldSecond.snp.makeConstraints {
            $0.left.equalTo(wordTitleSecond.snp.right).offset(8)
            $0.top.equalTo(textFieldFirst.snp.bottom).offset(28)
            $0.right.equalTo(addView).inset(22)
            $0.height.equalTo(wordTitleSecond.snp.height)
        }
        textFieldThird.snp.makeConstraints {
            $0.left.equalTo(wordTitleThird.snp.right).offset(8)
            $0.top.equalTo(textFieldSecond.snp.bottom).offset(28)
            $0.right.equalTo(addView).inset(22)
            $0.height.equalTo(wordTitleThird.snp.height)
        }
        uploadImageView.snp.makeConstraints {
            $0.top.equalTo(wordTitleThird.snp.bottom).offset(16)
            $0.left.right.equalTo(addView)
        }
        let imageAddGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        imageAddGesture.numberOfTapsRequired = 1
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(imageAddGesture)
    }
    
    override func viewWillLayoutSubviews() {
        // Do any additional setup after loading the view.
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        self.navigationItem.rightBarButtonItem = add
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    @objc func addTapped() {
        var imageUrl : String

        if imagePick {
            imageUrl = convertImageToBase64(uploadImageView.image!)
        } else {
            imageUrl = ""
        }
            
        if textFieldFirst.text! != "" && textFieldSecond.text! != "" && textFieldThird.text! != "" {
        
        } else {
            let alert = UIAlertController(title: "알림", message: "글을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
                alert.addAction(cancel)
            self.present(alert, animated: false)
        }
    }
}

extension AddViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uploadImageView.image = image
            uploadImageView.reloadInputViews()
            imagePick = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addPhoto(_ sender: UIGestureRecognizer) {

        let alert =  UIAlertController(title: "시 이미지", message: "시에 추가할 이미지를 선택해주세요", preferredStyle: .actionSheet)
        
        let importFromAlbum = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            picker.allowsEditing = true
            self.present(picker, animated:  true, completion: nil )
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(importFromAlbum)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}


