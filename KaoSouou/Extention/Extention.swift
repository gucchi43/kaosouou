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
