//
//  CustomOverlay.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/12/07.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import SwiftyOnboard
import TTTAttributedLabel

class CustomOverlay: SwiftyOnboardOverlay {
    
    @IBOutlet weak var pathButton: UIButton!
    @IBOutlet weak var announceLabel: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomOverlay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func configure() {
//        signUpButton.layer.borderColor = UIColor.twitter.cgColor
//        signUpButton.backgroundColor = UIColor.clear
//        signUpButton.layer.borderWidth = 1
//        signUpButton.layer.cornerRadius = signUpButton.bounds.height / 2
//        signUpButton.setTitleColor(UIColor.twitter, for: .normal)
//        signUpButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
//        signUpButton.setTitle(String.fontAwesomeIcon(name: .twitter) + " で登録 / ログイン !", for: .normal)
//
        pathButton.setTitle("スキップ", for: .normal)
        pathButton.isHidden = false
        
        announceLabel.delegate = self
        announceLabel.linkAttributes = [kCTForegroundColorAttributeName as AnyHashable: UIColor.blue,
                                        NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        announceLabel.activeLinkAttributes = [kCTForegroundColorAttributeName as AnyHashable: UIColor.blue]
        if let text = announceLabel.text {
//            announceLabel.addLink(to: URL(string: "https://yolo-app-tos.pagedemo.co/"), with: NSString(string: text).range(of: "利用規約"))
//            announceLabel.addLink(to: URL(string: "https://yolo-app-privacy.pagedemo.co/"), with: NSString(string: text).range(of: "プライバシーポリシー"))
        }
    }
    
    func lastPageConfigure() {
        signUpButton.layer.borderColor = UIColor.twitter.cgColor
        signUpButton.backgroundColor = UIColor.twitter
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = signUpButton.bounds.height / 2
        signUpButton.setTitleColor(UIColor.text3, for: .normal)
        signUpButton.setTitle(String.fontAwesomeIcon(name: .twitter) + " で登録 / ログイン !!!", for: .normal)
        
        pathButton.isHidden = true
    }
}

extension CustomOverlay: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let safariViewController = SFSafariViewController(url: url)
        let currentViewController = parentViewController()
        currentViewController?.present(safariViewController, animated: true, completion: nil)
    }
}

