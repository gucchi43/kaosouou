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
    
    
//    func makeServiceCall() {
//        indicator.startAnimating()
//        if let authUser = Auth.auth().currentUser {
//            Firebase.User.get(authUser.uid, block: { (user, error) in
//                self.indicator.stopAnimating()
//                if let user = user {
//                    Firebase.User.current = user
//                    DispatchQueue.main.async {
//                        AppDelegate.shared.rootViewController.switchToMainScreen()
//                    }
//                } else {
//                    // ユーザーがなかったらログアウトしてトップへ。
//                    try? Auth.auth().signOut()
//                    DispatchQueue.main.async {
//                        AppDelegate.shared.rootViewController.showLoginScreen()
//                    }
//                }
//            })
//        } else {
//            self.indicator.stopAnimating()
//            DispatchQueue.main.async {
//                AppDelegate.shared.rootViewController.showLoginScreen()
//            }
//        }
//    }
    
    
    
//    func goMain() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateInitialViewController() as! ViewController
//        present(viewController, animated: true, completion: nil)
//    }
//    
//    func goTop() {
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let viewController = storyboard.instantiateInitialViewController() as! LoginViewController
//        present(viewController, animated: true, completion: nil)
//    }
    
}
