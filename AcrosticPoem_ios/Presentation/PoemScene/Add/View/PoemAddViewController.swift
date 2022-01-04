//
//  PoemAddViewController.swift
//  AcrosticPoem_ios
//
//  Created by SuperMove on 2022/01/04.
//  Copyright © 2022 Minestrone. All rights reserved.
//

import UIKit
import RxSwift

class PoemAddViewController : UIViewController {

    private var viewModel : PoemAddViewModel!
    private var disposeBag = DisposeBag()
    
    private var isImagePicked = false
    
    private func bind() {
        assert(viewModel != nil)
        
    }
    
    override func viewWillLayoutSubviews() {
            // Do any additional setup after loading the view.
            self.navigationItem.rightBarButtonItem = add
            self.navigationController?.navigationBar.topItem?.title = ""
        }
    
    static func create(with viewModel: PoemAddViewModel) -> PoemAddViewController {
        let view = PoemAddViewController()
        view.viewModel = viewModel
        return view
    }
    
    let poemView = UIView()
    
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
       
    let titleBackgroundImage = UIImageView().then {
        $0.image = UIImage(named: "title_3")
        $0.contentMode = .scaleAspectFit
    }
       
    let todayTitle = UILabel().then {
           
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "HYgsrB", size: 32)
        $0.textColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
    }
       
       let addView = UIView()
       
       let textFieldFirst = WordInputField()
       let textFieldSecond = WordInputField()
       let textFieldThird = WordInputField()
       
       var titleFirst : String? = nil
       var titleSecond : String? = nil
       var titleThird : String? = nil
       
    let uploadImageView = UIImageView().then {
           $0.image = UIImage(named: "add_image")
           $0.contentMode = .scaleAspectFill
           $0.layer.cornerRadius = 10
           $0.layer.borderWidth = 1.5
           $0.clipsToBounds = true
           $0.layer.borderColor = UIColor(red:0.66, green:0.58, blue:0.56, alpha:1.0).cgColor
    }
    
    func initView() {
           view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.00)
           
           view.addSubview(poemView)
           
           poemView.addSubview(titleBackgroundImage)
           poemView.addSubview(todayTitle)
           
           view.addSubview(addView)
           addView.addSubview(textFieldFirst)
           addView.addSubview(textFieldSecond)
           addView.addSubview(textFieldThird)
           addView.addSubview(uploadImageView)
           
           
           
           textFieldFirst.textFieldView.attributedPlaceholder = NSAttributedString(string: "최대 30글자",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
           textFieldSecond.textFieldView.attributedPlaceholder = NSAttributedString(string: "표현의 자유 보장",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
           textFieldThird.textFieldView.attributedPlaceholder = NSAttributedString(string: "사진도 등록해봐요",
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
            $0.top.leading.trailing.equalTo(addView).inset(20)
           }
           textFieldSecond.snp.makeConstraints {
               $0.top.equalTo(textFieldFirst.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(addView).inset(20)
           }
           textFieldThird.snp.makeConstraints {
               $0.top.equalTo(textFieldSecond.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(addView).inset(20)
           }
           uploadImageView.snp.makeConstraints {
               $0.top.equalTo(textFieldThird.snp.bottom).offset(20)
                $0.leading.trailing.equalTo(addView).inset(20)
               $0.height.equalTo(200)
           }
           
           textFieldFirst.wordView.text = "\(titleFirst ?? "삼") :"
           textFieldSecond.wordView.text = "\(titleSecond ?? "행") :"
           textFieldThird.wordView.text = "\(titleThird ?? "시") :"
           
           uploadImageView.isUserInteractionEnabled = true
           uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
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
//                    viewModel.requestPoemAdd(image: imageUrl, word: [Word(word: self.textFieldFirst.wordView.text!, line: textFieldFirst.textFieldView.text!), Word(word: self.textFieldSecond.wordView.text!, line: textFieldSecond.textFieldView.text!), Word(word: self.textFieldThird.wordView.text!, line: textFieldThird.textFieldView.text!)])
                }
            }
        }

}

extension PoemAddViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
