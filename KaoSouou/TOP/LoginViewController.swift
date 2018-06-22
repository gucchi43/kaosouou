//
//  LoginViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/03/15.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import FacebookLogin
import FacebookCore
import Firebase
import Pring
import SwiftyJSON
import SVProgressHUD
import TwitterKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var twLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func tapFBLoginButton(_ sender: Any) {
        fbLogin()
    }
    
    @IBAction func tapTWLoginButton(_ sender: Any) {
        twLogin()
    }
    
    func twLogin() {
            TWTRTwitter.sharedInstance().logIn { (session, error) in
                SVProgressHUD.show()
                guard let session = session else {
                    print(error?.localizedDescription ?? "")
                    self.signUpErrorAlert()
                    return
                }
                
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                Auth.auth().signIn(with: credential, completion: { (authUser, error) in
                    if let error = error {
                        let castedError = error as NSError
                        let firebaseError = AuthErrorCode(rawValue: castedError.code)
                        print("firebaseError : ", firebaseError)
                        return
                    }
                    guard let authUser = authUser else {
                        print(error?.localizedDescription ?? "")
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    User.get(authUser.uid, block: { (user, error) in
                        if let user = user {
                            // すでにユーザーがある場合はそのままログイン
                            user.fcmToken = Messaging.messaging().fcmToken!
                            AccountManager.shared.currentUser = user
                            AccountManager.shared.currentUser!.update({ (error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    SVProgressHUD.dismiss()
                                    return
                                } else {
                                    SVProgressHUD.dismiss()
                                    DispatchQueue.main.async {
                                        AppDelegate.shared.rootViewController.switchToMainScreen()
                                    }
                                }
                            })
                        } else {
                            // ない場合はユーザーを作る
                            self.twSignUpNewUser(newUserId: authUser.uid, session: session, success: { photoUrl in
                                // 新規登録成功
                                SVProgressHUD.dismiss()
                                DispatchQueue.main.async {
                                    AppDelegate.shared.rootViewController.switchToSetProfile(with: photoUrl)
                                }
                            }, failure: {
                                // 新規登録失敗
                                self.signUpErrorAlert()
                            })

                        }
                    })
                })
            }
    }
    
    func twSignUpNewUser(newUserId: String, session: TWTRSession, success: @escaping(URL?) -> Void, failure: @escaping() -> Void) {
        let client = TWTRAPIClient.withCurrentUser()
        client.loadUser(withID: session.userID, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                failure()
            }
            if let user = user {
                let newUser = User(id: newUserId)
                newUser.originId = user.userID
                newUser.displayName = user.screenName
                newUser.hensachi = 50
                newUser.fcmToken = Messaging.messaging().fcmToken!
                newUser.save { (reference, error) in
                    if let error = error {
                        print(error)
                        failure()
                    } else {
                        print(reference)
                        AccountManager.shared.currentUser = newUser
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            if granted {
                                print("プッシュ通知ダイアログ 許可")
                                UIApplication.shared.registerForRemoteNotifications()
                            } else {
                                print("プッシュ通知ダイアログ 拒否")
                            }
                            success(URL(string: user.profileImageLargeURL))
                        })
                    }
                }
            }
        })
    }
    
    
    func fbLogin() {
        let loginManeger = LoginManager()
        loginManeger.logIn(readPermissions: [.email, .publicProfile, .userFriends], viewController: self) { (result) in
            SVProgressHUD.show()
            switch result {
            case .success(let permission, let declinePemisson, let token):
                print("success!!!")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                Auth.auth().signIn(with: credential, completion: { (authUser, error) in
                    
                    if let error = error {
                        print("error", error)
                        self.signUpErrorAlert()
                    } else {
                        guard let authUser = authUser else {
                            self.signUpErrorAlert()
                            return
                        }
                        User.get(authUser.uid, block: { (user, error) in
                            if let user = user {
                                print("ログイン済み user info: ", user)
                                user.fcmToken = Messaging.messaging().fcmToken!
                                AccountManager.shared.currentUser = user
                                
                                AccountManager.shared.currentUser!.update({ (error) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        SVProgressHUD.dismiss()
                                        return
                                    } else {
                                        SVProgressHUD.dismiss()
                                        DispatchQueue.main.async {
                                            AppDelegate.shared.rootViewController.switchToMainScreen()
                                        }
                                    }
                                })
                            } else {
                                self.fbSignUpNewUser(newUserId: authUser.uid, success: { photoUrl in
                                    // 新規登録成功
                                    SVProgressHUD.dismiss()
                                    DispatchQueue.main.async {
                                        AppDelegate.shared.rootViewController.switchToSetProfile(with: photoUrl)
                                    }
                                }, failure: {
                                    // 新規登録失敗
                                    self.signUpErrorAlert()
                                })
                            }
                        })
                    }
                })
                
            case .failed(let error):
                print("error...", error)
                self.signUpErrorAlert()
            case .cancelled:
                print("cancelled")
                self.signUpErrorAlert()
                
            }
        }
    }
    
    func fbSignUpNewUser(newUserId: String, success: @escaping(URL?) -> Void, failure: @escaping() -> Void) {
        
        // userInfo parametars
        // var parameters: [String : Any]? = ["fields": "id, name, picture.width(480).height(480), gender"]
        
        let connection = GraphRequestConnection()
        var graphPath = "/me"
        var parameters: [String : Any]? = ["fields": "id, name, email, picture.width(480).height(480), gender"]
        var accessToken = AccessToken.current
        var httpMethod: GraphRequestHTTPMethod = .GET
        var apiVersion: GraphAPIVersion = .defaultVersion
        let userInfoGraphRequest = GraphRequest(graphPath: graphPath, parameters: parameters!, accessToken: accessToken, httpMethod: httpMethod, apiVersion: apiVersion)
        connection.add(userInfoGraphRequest) { httpResponse, result in
            switch result {
            case .success(let response):
                
                print("Graph Request Succeeded: \(response)")
                if let userInfo = response.dictionaryValue {
                    let json = JSON(userInfo)
                    
                    print("newUserId: ", newUserId)
                    
                    let newUser = User(id: newUserId)
                    if let id = json["id"].string {
                        newUser.originId = id
                    }
                    if let name = json["name"].string {
                        newUser.displayName = name
                    }
                    if let email = json["email"].string {
                        newUser.email = email
                    }
                    newUser.hensachi = 50
                    newUser.fcmToken = Messaging.messaging().fcmToken!
                    newUser.save { (reference, error) in
                        if let error = error {
                            print(error)
                            failure()
                        } else {
                            print(reference)
                            AccountManager.shared.currentUser = newUser
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                if granted {
                                    print("プッシュ通知ダイアログ 許可")
                                    UIApplication.shared.registerForRemoteNotifications()
                                } else {
                                    print("プッシュ通知ダイアログ 拒否")
                                }
                                if let pictureUrl = json["picture"]["data"]["url"].url{
                                    success(pictureUrl)
                                } else {
                                    success(nil)
                                }
                            })
                            
                        }
                    }
                } else {
                    failure()
                }
            case .failed(let error):
                print("Graph Request Failed: \(error)")
                failure()
            }
        }
        connection.start()
    }
    
    func signUpErrorAlert() {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "サインインに失敗しました", message: "もう一度お試しください", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            // TODO: 写真削除実装
        }
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
