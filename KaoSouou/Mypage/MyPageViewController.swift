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

class MyPageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var hensachiLabel: UILabel!
    @IBOutlet weak var kaisuLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var bellButton: MIBadgeButton!
    
    @IBOutlet weak var firstNumImageView: UIImageView!
    @IBOutlet weak var secondNumImageView: UIImageView!
    @IBOutlet weak var thirdNumImageView: UIImageView!
    @IBOutlet weak var dotImageView: UIImageView!
        
    var userDataSourse: DataSource<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faceImageView.clipsToBounds = true
        faceImageView.contentMode = .scaleAspectFill
        setLongPress()
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
        closeButton.btnShadow(radius: 0.5, opacity: 0.5)
    }
    
    func getUserDataSource() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        userDataSourse = User.where(\User.originId, isEqualTo: currentUser.originId).limit(to: 1).dataSource().on({ (snapShot, changes) in
            switch changes {
            case .initial:
                self.loadData()
            case .update(let deletions, let insertions, let modifications):
                self.loadData()
            case .error(let error):
                print(error)
            }
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
        setNeon(hensachi: currentUser.hensachi.shisyagonyu())
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
        let terms = UIAlertAction(title: "利用規約", style: .default) { (action) in
            print("利用規約")
            let postUrl = URL(string:"https://faceislife.studio.design/support/terms")
            UIApplication.shared.open(postUrl!)
        }
        let privacy = UIAlertAction(title: "プライバシーポリシー", style: .default) { (action) in
            print("プライバシーポリシー")
            let postUrl = URL(string:"https://faceislife.studio.design/support/privacy")
            UIApplication.shared.open(postUrl!)
        }
        let questoin = UIAlertAction(title: "Twitterで問い合わせ", style: .default) { (action) in
            print("問い合わせ")
            
            let postUrl = URL(string: "http://twitter.com/faceislife")
            UIApplication.shared.open(postUrl!, options: [:], completionHandler: nil)
            
//            if UIApplication.shared.canOpenURL(URL(string: "twitter://")!) {
//
//
//
////                let postUrl = URL(string: "http://twitter.com/faceislife")
////                UIApplication.shared.open(postUrl!, options: [:], completionHandler: nil)
//
////                let postUrl = URL(string: "twitter:@faceislife")
////                print("Twitter インストール済み")
////                UIApplication.shared.open(postUrl!, options: [:], completionHandler: nil)
//            } else {
////                let postUrl = URL(string: "http://twitter.com/%@faceislife")
////                UIApplication.shared.open(postUrl!, options: [:], completionHandler: nil)
//            }
        }
        let logOut = UIAlertAction(title: "ログアウト", style: .destructive) { (action) in
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
            let sb = UIStoryboard(name: "Onboard", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! OnboardViewController
            vc.fromAppHelp = true
            self.present(vc, animated: true) {
                print("go to loveUserList")
            }
        }
        
        let otherMenu = UIAlertAction(title: "その他", style: .default) { (action) in
            print("その他")
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (actiona) in
            print("キャンセル")
        }
        
        alert.addAction(profileEdit)
        alert.addAction(questoin)
        alert.addAction(tutorial)
        alert.addAction(terms)
        alert.addAction(privacy)
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
    
    func setNeon(hensachi: Double) {
        guard let user = AccountManager.shared.currentUser else { return }
        let firstNum = hensachi / 10
        let secondNum = hensachi.truncatingRemainder(dividingBy: 10) / 1
        let thirdNum = hensachi.truncatingRemainder(dividingBy: 1)
        var key = "j"
        if user.gender == 2 {
            //女子
            key = "j"
        } else {
            //男子
            key = "d"
        }
        firstNumImageView.image = UIImage(named: key + String(firstNum))
        secondNumImageView.image = UIImage(named: key + String(secondNum))
        thirdNumImageView.image = UIImage(named: key + String(thirdNum))
        dotImageView.image = UIImage(named: key + "dot")
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
        bellButton.badgeString = ""
        let sb = UIStoryboard(name: "NotificationList", bundle: nil)
        let nc = sb.instantiateInitialViewController() as! UINavigationController
        present(nc, animated: true) {
            print("go to notification")
        }
    }
    
    func setLongPress() {
        let longPressGesture =
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(MyPageViewController.longPress(_:)))
        longPressGesture.delegate = self
        effectView.addGestureRecognizer(longPressGesture)
    }
    
    // Long Press イベント
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            print("LongPress began")
            effectView.isHidden = true
        }
        else if sender.state == .ended {
            effectView.isHidden = false
        }
    }
}
