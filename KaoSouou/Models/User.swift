//
//  User.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/03/15.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import Foundation
import Firebase
import Pring

@objcMembers
class User : Object{
    dynamic var originId: String = ""
    dynamic var displayName: String = ""
    dynamic var email: String = ""
    dynamic var photoFile: File?
    dynamic var hensachi: Double = 0
    dynamic var gender: Int = 0
    dynamic var birthday: String = ""
    dynamic var kaisu: Int = 0
    dynamic var loveUsers: ReferenceCollection<User> = []
    dynamic var notificationItems: ReferenceCollection<NotificationItem> = []
    dynamic var results: ReferenceCollection<Result> = []
    dynamic var fcmToken: String = ""
    dynamic var badgeNum: Int = 0
}

