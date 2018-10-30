//
//  Extention.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/14.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addUnderline(width: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

extension UILabel {
    func lblShadow(radius: CGFloat, opacity: Float){
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIButton {
    func btnShadow(radius: CGFloat, opacity: Float){
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension Double {
    mutating func shisyagonyu() -> Double{
        print("変更前 : ", self)
        let output = Darwin.round(self * 10) / 10
        print("変更後 : ", output)
        return output
    }
}

extension UIColor {
    
    class func twitterColor() -> UIColor{
        return UIColor.rgbColor(rgbValue: 0x00ACED)
    }
    
    class func facebookColor() -> UIColor{
        return UIColor.rgbColor(rgbValue: 0x305097)
    }
    
    class func lineColor() -> UIColor{
        return UIColor.rgbColor(rgbValue: 0x5AE628)
    }
    
    class func imageBGColor() -> UIColor{
        return UIColor.lightGray
    }
    
    class func boyBrandColor() -> UIColor{
        return UIColor.rgbColor(rgbValue: 0x00FF92)
    }
    
    class func girlBrandColor() -> UIColor{
        return UIColor.rgbColor(rgbValue: 0xF743BC)
    }
    
    class func rgbColor(rgbValue: UInt) -> UIColor{
        return UIColor(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >>  8) / 255.0,
            blue:  CGFloat( rgbValue & 0x0000FF)        / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
