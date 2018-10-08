//
//  AccountManager.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/03/15.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit

class AccountManager: NSObject {
    static let shared = AccountManager()
    var currentUser: User?
}

