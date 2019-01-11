//
//  CustomFirstView.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2019/01/11.
//  Copyright © 2019年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import SwiftyOnboard


class CustomFirstView: SwiftyOnboardPage {
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var image: UIImageView!
//    @IBOutlet weak var subTitleLabel: UILabel!
//    @IBOutlet weak var neonBarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomFirstView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
