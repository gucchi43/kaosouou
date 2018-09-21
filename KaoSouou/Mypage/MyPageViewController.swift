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
    
    var userDataSourse: DataSource<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDataSource()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setButton()
        loadBadge()
    }
    
    func setButton() {
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.clipsToBounds = true
    }
    
    func getUserDataSource() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        userDataSourse = User.where(\User.originId, isEqualTo: currentUser.originId).dataSource().on({ (snapShot, change) in
            self.loadData()
        }).listen()
    }
    
    func loadData() {
        guard let userDataSourse = userDataSourse else { return }
        let currentUser = userDataSourse.first!
        if currentUser.gender == 2 {
            self.self.userNameLabel.text = "💁‍♀️ \(currentUser.displayName)"
        } else {
            self.self.userNameLabel.text = "💁‍♂️ \(currentUser.displayName)"
        }
        self.faceImageView.loadUserImageView(with: currentUser)
        self.hensachiLabel.text = String(currentUser.hensachi.shisyagonyu())
        self.kaisuLabel.text = String(currentUser.kaisu)
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
            let sb = UIStoryboard(name: "SetProfile", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! SetProfileViewController
            vc.currentType = .edit
            self.show(vc, sender: nil)
        }
        
        let tutorial = UIAlertAction(title: "使い方", style: .default) { (action) in
            print("使い方")
//            let sb = UIStoryboard(name: "SetProfile", bundle: nil)
//            let vc = sb.instantiateInitialViewController() as! SetProfileViewController
//            vc.currentType = .edit
//            self.show(vc, sender: nil)
        }
        
        let otherMenu = UIAlertAction(title: "その他", style: .default) { (action) in
            print("その他")
//            let sb = UIStoryboard(name: "SetProfile", bundle: nil)
//            let vc = sb.instantiateInitialViewController() as! SetProfileViewController
//            vc.currentType = .edit
//            self.show(vc, sender: nil)
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (actiona) in
            print("キャンセル")
        }
        
        alert.addAction(profileEdit)
        alert.addAction(tutorial)
        alert.addAction(otherMenu)
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
    
    @IBAction func tapLovesButton(_ sender: Any) {
        print("プロフィール編集")
        let sb = UIStoryboard(name: "LoveUserList", bundle: nil)
        let nc = sb.instantiateInitialViewController() as! UINavigationController
        self.present(nc, animated: true) {
            print("go to loveUserList")
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
