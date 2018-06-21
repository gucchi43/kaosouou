//
//  Result.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/20.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import Foundation
import Firebase
import Pring

@objcMembers
class Result : Object{
    dynamic var voter: Reference<User> = .init()
    dynamic var first: Reference<User> = .init()
    dynamic var second: Reference<User> = .init()
    dynamic var third: Reference<User> = .init()
    dynamic var fource: Reference<User> = .init()
    dynamic var fifth: Reference<User> = .init()
    dynamic var sixth: Reference<User> = .init()
    dynamic var seventh: Reference<User> = .init()
    dynamic var eighth: Reference<User> = .init()
    dynamic var ninth: Reference<User> = .init()
}
