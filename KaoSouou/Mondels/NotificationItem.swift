//
//  NotificationItem.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/20.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import Foundation
import Pring

@objcMembers
class NotificationItem: Object {
    dynamic var to: Reference<User> = .init()
    dynamic var from: Reference<User> = .init()
    dynamic var result: Reference<Result> = .init()
    dynamic var num: String = "0"
    
    func setNotification(with fromUser: User, toUser: User, numInt: Int) {
        let notificationItem = NotificationItem()
        notificationItem.from.set(fromUser)
        notificationItem.to.set(toUser)
        notificationItem.num = String(numInt)
        toUser.update { (error) in
            if let error = error {
                print("toUser.notificationItems : ", error.localizedDescription)
            } else {
                print("toUser.notificationItems success")
            }
        }
    }
}


