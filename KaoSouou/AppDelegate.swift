//
//  AppDelegate.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/02/19.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FacebookCore
import FacebookLogin
import TwitterKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        TWTRTwitter.sharedInstance().start(withConsumerKey: "DyJOMzGoIhMwoqy7WWUBMDi4f", consumerSecret: "5L2OcAKETFKcsTOwHLNDpRGkamaBjk8XufWUOSOE6xC4G3ApRV")
        Fabric.with([Crashlytics.self])
        
        UNUserNotificationCenter.current().delegate = self
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = RootViewController()
        self.window?.makeKeyAndVisible()
        //ナビゲーションアイテムの色を変更
        UINavigationBar.appearance().tintColor = UIColor.white
        //ナビゲーションバーの背景を変更
        UINavigationBar.appearance().barTintColor = UIColor.black
        //ナビゲーションのタイトル文字列の色を変更
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }  else {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("userInfo : ", userInfo)
        // アプリが起動している間に通知を受け取った場合の処理を行う。
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // アプリがバックグラウンド状態の時に通知を受け取った場合の処理を行う。
        print("userInfo : ", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("プッシュ通知登録失敗 : ", error)
        // システムへのプッシュ通知の登録が失敗した時の処理を行う。
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Device Token を取得した時の処理を行う。
        print("APNs token retrieved: \(deviceToken)")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS 10 以降では通知を受け取るとこちらのデリゲートメソッドが呼ばれる。
    // foreground で受信
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        // Push Notifications のmessageを取得
        let badge = content.badge
        let body = notification.request.content.body
        let toOriginId = content.userInfo["toUserOriginId"] as! String
        print("content : ", content)
        print("userNotificationCenterのwillPresentから: \(body), \(badge)")
        
        // ログインしてるユーザーのみ通す
        if let currentUser = AccountManager.shared.currentUser {
            if currentUser.originId == toOriginId {
                //　iphone7 haptic feedback
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                // audio & vibrater
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil)
                showNotificationAlert()
            }
        }
        completionHandler([])
    }
    
    // background で受信してアプリを起動
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Push Notifications のmessageを取得
        let content = response.notification.request.content
        let badge = content.badge
        let body = response.notification.request.content.body
        let toOriginId = content.userInfo["toUserOriginId"] as! String
        print("userNotificationCenterのdidReceiveから: \(body), \(badge)")
        print("content : ", content)
        // ログインしてるユーザーのみ通す
        if let currentUser = AccountManager.shared.currentUser {
            if currentUser.originId == toOriginId {
                showNotificationAlert()
            }
        }
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}

extension AppDelegate {
    func showNotificationAlert() {
        let alert = UIAlertController(title: "新しくチョイスされたよ！", message: "何位だったか確認してみよう！", preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "チェケラ！", style: .default) { (action) in
            print("画面遷移")
            let notificationSB = UIStoryboard(name: "NotificationList", bundle: nil)
            let notificationVC = notificationSB.instantiateInitialViewController() as! UINavigationController
            if let topController = UIApplication.topViewController() {
                topController.show(notificationVC, sender: nil)
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "やめとく", style: .destructive) { (action) in
            print("Cancel")
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        if let topController = UIApplication.topViewController() {
            topController.present(alert, animated: true, completion: nil)            
        }
    }
}
