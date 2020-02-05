//
//  PoemAddViewController.swift
//  AcrosticPoem_ios
//
//  Created by Yang on 2019/11/15.
//  Copyright © 2019 Minestrone. All rights reserved.
//

import UIKit

class PoemAddViewController: UIViewController{
    
    let picker = UIImagePickerController()
    
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
    
    @IBOutlet var selectedImage: UIImageView!
    
    @IBOutlet var submitPoemButton: UIBarButtonItem!
    
    var PoemInfo : PoemPostModel?
    
    private var imagePick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(todayTitle: ad!.titleString!)
    }

    // MARK: - 등록 버튼 이벤트
    @IBAction func submitPoemAction(_ sender: Any) {
        var imageUrl : String
        
        if imagePick {
                   imageUrl = convertImageToBase64(selectedImage.image!)
               }else{
                   imageUrl = ""
               }
        
        if TextFirst.text != "" && TextSecond.text != "" && TextThird.text != "" {
            PoemInfo = PoemPostModel(token: UserDefaults.standard.value(forKey: "GuestToken") as! String, Image: imageUrl, word: [Word(word: titleFirst.text!, line: TextFirst.text!),Word(word: titleSecond.text!, line: TextSecond.text!),Word(word:  titleThird.text!, line: TextThird.text!)])
                    
                    DispatchQueue.global().async {
                        NetworkManager().submitPoem(postPoemModel: self.PoemInfo!)
            }
            performSegue(withIdentifier: "unwindToMain", sender: self)
        }
        else {
            let alert = UIAlertController(title: "알림", message: "글을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
            alert.addAction(cancel)
            self.present(alert, animated: false)
        }
    }
    
    // MARK: - 뷰 초기화
    private func initView(todayTitle : String) {
        
        let importGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        selectedImage.addGestureRecognizer(importGesture)
        selectedImage.isUserInteractionEnabled = true
        
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

// MARK: - UIImagePicker
extension PoemAddViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage.image = image
            imagePick = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addPhoto(_ sender: UIBarButtonItem) {

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
    
    // Base64 형식으로 이미지 변환
    func convertImageToBase64(_ image: UIImage) -> String {
           let imageData:NSData = image.jpegData(compressionQuality: 0.4)! as NSData
              let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
              return strBase64
       }
}
