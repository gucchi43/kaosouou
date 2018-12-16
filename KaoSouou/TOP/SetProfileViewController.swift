//
//  SetProfileViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/13.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Pring
import Kingfisher
import SVProgressHUD
import RSKImageCropper

enum stateType {
    case initial, edit
}

class SetProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBaseImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var photoUrl: URL?
    var currentType = stateType.initial
    var newImage: UIImage?
    
    @IBOutlet weak var profileImageWidth: NSLayoutConstraint!
    @IBOutlet weak var profileImageHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setData()
    }
    
    func configure() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileBaseImageView.contentMode = .scaleAspectFill
        profileBaseImageView.clipsToBounds = true
        profileImageHeight.constant = UIScreen.main.bounds.size.height / 3
        profileImageWidth.constant = UIScreen.main.bounds.size.width / 3
        nameTextField.addUnderline(width: 1.0, color: UIColor.white)
        nextButton.layer.cornerRadius = nextButton.bounds.height / 2
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.white.cgColor
        nextButton.clipsToBounds = true
    }
    
    func setData() {
        guard let user = AccountManager.shared.currentUser else { return }
        nameTextField.text = user.displayName
        if let photoUrl = photoUrl {
            // 最初のユーザー登録時
            self.profileImageView.loadUrlImageView(url: photoUrl)
            self.profileBaseImageView.loadUrlImageView(url: photoUrl)
        } else {
            if let newImage = newImage {
                self.profileImageView.image = newImage
                self.profileBaseImageView.image = newImage
            } else {
                self.profileImageView.loadUserImageView(with: user)
                self.profileBaseImageView.loadUserImageView(with: user)
            }
        }
    }
    
    @IBAction func tapUserProfileImageView(_ sender: Any) {
        showImagePickerController()
    }
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapNextButton(_ sender: Any) {
        guard let user = AccountManager.shared.currentUser else { return }
        SVProgressHUD.show()
        user.displayName = nameTextField.text ?? ""
        if let image = profileImageView.image, let photoData = UIImageJPEGRepresentation(image, 0.5) {
            user.photoFile = File(data: photoData)
        }
        user.update { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    switch self.currentType {
                    case .initial:
                        AppDelegate.shared.rootViewController.switchToGenderSelect()
                    case .edit:
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension SetProfileViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            nameTextField.resignFirstResponder()
        }
        return true
    }
}

extension SetProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.custom)
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        picker.show(imageCropVC, sender: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SetProfileViewController : RSKImageCropViewControllerDelegate {

    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func imageCropViewController(_ controller: RSKImageCropViewController!, willCropImage originalImage: UIImage!) {
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        newImage = croppedImage
        self.dismiss(animated: true, completion: nil)
    }
}

extension SetProfileViewController : RSKImageCropViewControllerDataSource {
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var width, height: CGFloat!
        
        width =  UIScreen.main.bounds.size.width
        height =  UIScreen.main.bounds.size.height
        maskSize = CGSize(width: width, height: height)
        
        var maskRect: CGRect = CGRect(x: 48, y: 48, width: maskSize.width - 96, height: maskSize.height - 96)
        
        return maskRect
    }
    
    // トリミングしたい領域を描画（今回は四角な領域です・・・）
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath! {
        var rect: CGRect = controller.maskRect
        
        var point1: CGPoint = CGPoint(x: rect.minX, y: rect.maxY)
        var point2: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        var point3: CGPoint = CGPoint(x: rect.maxX, y: rect.minY)
        var point4: CGPoint = CGPoint(x: rect.minX, y: rect.minY)
        var square: UIBezierPath = UIBezierPath()

        square.move(to: point1)
        square.addLine(to: point2)
        square.addLine(to: point3)
        square.addLine(to: point4)
        square.close()
        return square
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
}
