//
//  MyPageViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/05/07.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Pring
import Firebase
import Kingfisher
import MIBadgeButton_Swift
import FontAwesome_swift

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var hensachiLabel: UILabel!
    @IBOutlet weak var kaisuLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var bellButton: MIBadgeButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setButton()
        loadBadge()
        configure()
    }
    
    func configure() {
        if let currentUser = AccountManager.shared.currentUser{
            User.get(currentUser.id) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if currentUser.gender == 2 {
                        self.userNameLabel.text = "💁‍♀️ \(user!.displayName)"
                    } else {
                        self.userNameLabel.text = "💁‍♂️ \(user!.displayName)"
                    }
                    self.faceImageView.loadUserImageView(with: user!)
                    self.hensachiLabel.text = String(user!.hensachi)
                    self.kaisuLabel.text = String(user!.kaisu)
                }
            }
        }
    }
    
    func setButton() {
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.clipsToBounds = true
    }
    
    func loadBadge() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        print("badgeの生存確認 : ",currentUser.badgeNum)
        if currentUser.badgeNum > 0{
            bellButton.badgeString = String(currentUser.badgeNum)
        }
    }
    
    @IBAction func tapSettingButton(_ sender: Any) {
        let alert = UIAlertController(title: "設定", message: nil, preferredStyle: .actionSheet)
        let logOut = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            print("ログアウト")
            self.logout {
                print("ログアウト成功")
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: {
                        AccountManager.shared.currentUser = nil
                        AppDelegate.shared.rootViewController.switchToLogin()
                    })
                }
            }
        }
        let profileEdit = UIAlertAction(title: "プロフィール編集", style: .default) { (action) in
            print("プロフィール編集")
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (actiona) in
            print("キャンセル")
        }
        alert.addAction(profileEdit)
        alert.addAction(logOut)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func logout(_ completion: @escaping () -> Void) {
        let user = AccountManager.shared.currentUser
        user?.update({ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                try? Auth.auth().signOut()
                //                AccountManager.shared.currentUser = nil
                completion()
            }
        })
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Mypage Close")
        }
    }
    
    @IBAction func tapBellButton(_ sender: Any) {
        let notificationSB = UIStoryboard(name: "NotificationList", bundle: nil)
        let notificationVC = notificationSB.instantiateInitialViewController()
        present(notificationVC!, animated: true) {
            print("go to notification")
        }
    }
    
}
