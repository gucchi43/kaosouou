//
//  GenderSelectViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/05/21.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import SVProgressHUD

class GenderSelectViewController: UIViewController {
    
    @IBOutlet weak var boyButton: UIButton!
    @IBOutlet weak var girlButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var gender: genderType?
    
    enum genderType: Int {
        case boy = 1
        case girl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        
        nextButton.isHidden = true
        nextButton.isEnabled = false
    }
    
    func setButton() {
        nextButton.layer.cornerRadius = nextButton.bounds.height / 2
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.white.cgColor
        nextButton.clipsToBounds = true
    }
    
    @IBAction func tapBoyButton(_ sender: Any) {
        gender = genderType.boy
        nextButton.isHidden = false
        nextButton.isEnabled = true
        boyButton.titleLabel?.font = UIFont.systemFont(ofSize: 80)
        girlButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
    }
    
    @IBAction func tapGirlButton(_ sender: Any) {
        gender = genderType.girl
        nextButton.isHidden = false
        nextButton.isEnabled = true
        boyButton.titleLabel?.font = UIFont.systemFont(ofSize: 48)
        girlButton.titleLabel?.font = UIFont.systemFont(ofSize: 80)
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        next()
    }
    
    func next() {
        if let gender = gender {
            let currentUser = AccountManager.shared.currentUser
            currentUser?.gender = gender.rawValue
            currentUser?.update({ (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {                    
                    print("gender設定成功")
                    AppDelegate.shared.rootViewController.showMainScreen()
                }
            })
        } else {
            print("gender設定してない")
        }
    }
}
