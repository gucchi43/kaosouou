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
        
        if agodate.toUnit(.minute)! < 60 {
            agoText = String(agodate.toUnit(.minute)!) + "分前"
        } else if agodate.toUnit(.hour)! < 24 {
            agoText = String(agodate.toUnit(.hour)!) + "時間前"
        } else if agodate.toUnit(.day)! < 7 {
            agoText = String(agodate.toUnit(.day)!) + "日前"
        } else if agodate.toUnit(.month)! < 1 {
            agoText = String(agodate.toUnit(.day)! / 7) + "週間前"
        } else {
            agoText = String(agodate.toUnit(.month)!) + "ヶ月前"
        }
        print("変換Date before", self)
        print("変換Date after", agoText)
        return agoText
    }
}


