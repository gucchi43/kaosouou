//
//  Date+Extension.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/21.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import SwiftDate

extension Date {
    func convertAgoText() -> String {
        var agoText: String!
        let agodate = self.timeIntervalSinceNow * -1
        if agodate.in(.minute)! < 60 {
            agoText = String(agodate.in(.minute)!) + "分前"
        } else if agodate.in(.hour)! < 24 {
            agoText = String(agodate.in(.hour)!) + "時間前"
        } else if agodate.in(.day)! < 7 {
            agoText = String(agodate.in(.day)!) + "日前"
        } else if agodate.in(.month)! < 1 {
            agoText = String(agodate.in(.day)! / 7) + "週間前"
        } else {
            agoText = String(agodate.in(.month)!) + "ヶ月前"
        }
        return agoText
    }
}


