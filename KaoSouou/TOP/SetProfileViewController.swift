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

class SetProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var photoUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        configure()
    }
    
    func configure() {
        guard let user = AccountManager.shared.currentUser else { return }
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        nameTextField.addUnderline(width: 1.0, color: UIColor.white)
        if let photoUrl = photoUrl {
            self.profileImageView.loadUrlImageView(url: photoUrl)
        }
        nameTextField.text = user.displayName
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
                    AppDelegate.shared.rootViewController.switchToGenderSelect()
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
        profileImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
