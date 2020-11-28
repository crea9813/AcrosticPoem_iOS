//
//  PoemAddView.swift
//  AcrosticPoem_ios
//
//  Created by Poto on 2020/11/28.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit
import RxSwift

class PoemAddView : UIViewController {
    let picker = UIImagePickerController()
    
    private var isImagePicked = false
    
    let disposeBag = DisposeBag()
    
    let viewModel = PoemAddViewModel()
    
    let poemView = UIView()
    
    let titleBackgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "title_3")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let todayTitle : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 32)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    let addView = UIView()
    
    let textFieldFirst = PoemInputView()
    let textFieldSecond = PoemInputView()
    let textFieldThird = PoemInputView()
    
    let uploadImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add_image")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0).cgColor
        return imageView
    }()
    
    private func bind() {
        viewModel.todayTitleSuccess.subscribe(onNext: {
            title in
            self.todayTitle.text = title
            self.todayTitle.addCharacterSpacing(kernValue: 30)
        }).disposed(by: disposeBag)
    }
    
    private func setTitle() {
        viewModel.requestTodayTitle(wordCount: 3)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTitle()
        bind()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(poemView)
        
        poemView.addSubview(titleBackgroundImage)
        poemView.addSubview(todayTitle)
        
        view.addSubview(addView)
        addView.addSubview(textFieldFirst)
        addView.addSubview(textFieldSecond)
        addView.addSubview(textFieldThird)
        addView.addSubview(uploadImageView)
        
        
        
        textFieldFirst.textFieldView.attributedPlaceholder = NSAttributedString(string: "  최대 30글자",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldSecond.textFieldView.attributedPlaceholder = NSAttributedString(string: "  표현의 자유 보장",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldThird.textFieldView.attributedPlaceholder = NSAttributedString(string: "  사진도 등록해봐요",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        poemView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleBackgroundImage.snp.makeConstraints {
            $0.width.equalTo(poemView.snp.width)
            $0.top.leading.trailing.equalTo(poemView)
        }
        
        todayTitle.snp.makeConstraints {
            $0.centerY.equalTo(titleBackgroundImage)
            $0.leading.trailing.equalTo(poemView)
        }

        addView.snp.makeConstraints {
            $0.top.equalTo(titleBackgroundImage.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        textFieldFirst.snp.makeConstraints {
            $0.top.equalTo(addView).offset(20)
            $0.leading.equalTo(addView).offset(20)
            $0.trailing.equalTo(addView).inset(20)
        }
        textFieldSecond.snp.makeConstraints {
            $0.top.equalTo(textFieldFirst.snp.bottom).offset(20)
            $0.leading.equalTo(addView).offset(20)
            $0.trailing.equalTo(addView).inset(20)
        }
        textFieldThird.snp.makeConstraints {
            $0.top.equalTo(textFieldSecond.snp.bottom).offset(20)
            $0.leading.equalTo(addView).offset(20)
            $0.trailing.equalTo(addView).inset(20)
        }
        uploadImageView.snp.makeConstraints {
            $0.top.equalTo(textFieldThird.snp.bottom).offset(20)
            $0.leading.equalTo(addView).offset(20)
            $0.trailing.equalTo(addView).inset(20)
            $0.height.equalTo(200)
        }
        
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
    }
    
    override func viewWillLayoutSubviews() {
        // Do any additional setup after loading the view.
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        self.navigationItem.rightBarButtonItem = add
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    @objc func addTapped() {
        var imageUrl : String

        if isImagePicked {
            imageUrl = convertImageToBase64(uploadImageView.image!)
        } else {
            imageUrl = ""
        }
            
        if textFieldFirst.textFieldView.text!.isEmpty && textFieldSecond.textFieldView.text!.isEmpty && textFieldThird.textFieldView.text!.isEmpty {
            AlertUtil.shared.showErrorAlert(vc: self, title: "알림", message: "글을 입력해주세요.")
        } else {
            if textFieldFirst.textFieldView.text![textFieldFirst.textFieldView.text!.startIndex] != textFieldFirst.wordView.text![textFieldFirst.wordView.text!.startIndex] || textFieldSecond.textFieldView.text![textFieldSecond.textFieldView.text!.startIndex] != textFieldSecond.wordView.text![textFieldSecond.wordView.text!.startIndex] || textFieldThird.textFieldView.text![textFieldThird.textFieldView.text!.startIndex] != textFieldThird.wordView.text![textFieldThird.wordView.text!.startIndex] {
                AlertUtil.shared.showErrorAlert(vc: self, title: "알림", message: "삼행시 규정에 맞게 다시 지어주세요")
            } else {
                //등록
            }
        }
    }
}

extension PoemAddView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uploadImageView.image = image
            uploadImageView.reloadInputViews()
            isImagePicked = true
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

class PoemInputView : UIView {
    
    let wordView : UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "HYgsrB", size: 27)
        title.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        
        return title
    }()
    
    let textFieldView : UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0).cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(wordView)
        self.addSubview(textFieldView)
        
        wordView.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(5)
            $0.bottom.equalTo(self).inset(5)
            $0.width.lessThanOrEqualTo(50)
        }
        textFieldView.snp.makeConstraints {
            $0.leading.equalTo(wordView.snp.trailing).offset(10)
            $0.top.equalTo(self)
            $0.bottom.equalTo(self)
            $0.trailing.equalTo(self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
