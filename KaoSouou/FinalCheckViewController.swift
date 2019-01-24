//
//  FinalCheckViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2019/01/22.
//  Copyright © 2019年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import M13Checkbox

class FinalCheckViewController: UIViewController {

    @IBOutlet weak var check1Box: M13Checkbox!
    @IBOutlet weak var check2Box: M13Checkbox!
    @IBOutlet weak var buttonContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        buttonContinue.layer.borderColor = UIColor.lightGray.cgColor
        buttonContinue.titleLabel?.textColor = .lightGray
        buttonContinue.layer.borderWidth = 1
        buttonContinue.layer.cornerRadius = buttonContinue.bounds.height / 2
        buttonContinue.clipsToBounds = true
        buttonContinue.isEnabled = false
        buttonContinue.isHidden = true
        if AccountManager.shared.currentUser!.gender == 2 {
            check1Box.tintColor = UIColor.girlBrandColor()
        } else {
            check1Box.tintColor = UIColor.boyBrandColor()
        }
    }
    
    @IBAction func changeValued1Box(_ sender: M13Checkbox) {
        switch sender.checkState {
        case .unchecked:
            break
        case .checked:
            break
        case .mixed:
            break
        }
        checkAllAllowed()
    }
    
    @IBAction func chengeValued2Box(_ sender: M13Checkbox) {
        switch sender.checkState {
        case .unchecked:
            
            break
        case .checked:
            
            break
        case .mixed:
            
            break
        }
        checkAllAllowed()
    }
    
    func checkAllAllowed() {
        // とりあえずチェック項目１つでを本番とする
//        if check1Box.checkState == .checked && check2Box.checkState == .checked {
        if check1Box.checkState == .checked {
            // ボタンをアクティブに
            buttonContinue.isEnabled = true
            buttonContinue.layer.borderColor = UIColor.white.cgColor
            buttonContinue.titleLabel?.textColor = .white
            buttonContinue.isHidden = false
        } else {
            //ボタンは非アクティブに
            buttonContinue.isEnabled = false
            buttonContinue.layer.borderColor = UIColor.lightGray.cgColor
            buttonContinue.titleLabel?.textColor = .lightGray
            buttonContinue.isHidden = true
        }
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        next()
    }
    
    
    func next() {
        let currentUser = AccountManager.shared.currentUser!
        currentUser.allowedFlag = true
        currentUser.update({ (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("allowedFlag設定成功")
                AppDelegate.shared.rootViewController.showMainScreen()
            }
        })
    }
    
    
}
