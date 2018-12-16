//
//  SplashViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/05/20.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.dismiss(animated: animated, completion: nil)
        rootCheck()
    }
    
    func rootCheck() {
        //ユーザーがいない場合サインイン画面に遷移
        if let authUser = Auth.auth().currentUser {
            User.get(authUser.uid, block: { (user, error) in
                if let user = user {
                    AccountManager.shared.currentUser = user
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            AppDelegate.shared.rootViewController.switchToMainScreen()
                            //検証用
//                            AppDelegate.shared.rootViewController.switchToBirthdaySelectScreen()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        // ユーザーがなかったらログアウトしてトップへ。
                        try? Auth.auth().signOut()
                        DispatchQueue.main.async {
                            AppDelegate.shared.rootViewController.showLoginScreen()
                        }
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                AppDelegate.shared.rootViewController.showLoginScreen()
            }
        }
    }
}
