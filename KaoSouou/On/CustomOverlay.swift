//
//  CustomOverlay.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SwiftyOnboard
import TTTAttributedLabel
import SafariServices

class CustomOverlay: SwiftyOnboardOverlay {
    
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var contentControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonContinue.layer.borderColor = UIColor.white.cgColor
        buttonContinue.layer.borderWidth = 1
        buttonContinue.layer.cornerRadius = buttonContinue.bounds.height / 2
        
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomOverlay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
//    func configure(noticeLabel: TTTAttributedLabel) {
//        noticeLabel.delegate = self
//        noticeLabel.linkAttributes = [kCTForegroundColorAttributeName as AnyHashable: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),
//                                      NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
//        noticeLabel.activeLinkAttributes = [kCTForegroundColorAttributeName as AnyHashable: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)]
//
//        if let text = noticeLabel.text {
////            noticeLabel.addLink(to: URL(string: "https://yolo-app-tos.pagedemo.co/"), with: NSString(string: text).range(of: "利用規約"))
////            noticeLabel.addLink(to: URL(string: "https://yolo-app-privacy.pagedemo.co/"), with: NSString(string: text).range(of: "プライバシーポリシー"))
//        }
//    }
}

extension CustomOverlay: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let safariViewController = SFSafariViewController(url: url)
        let currentViewController = parentViewController()
        currentViewController?.present(safariViewController, animated: true, completion: nil)
    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
}

