//
//  OnboardViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/12/08.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import SwiftyOnboard
import TTTAttributedLabel
import SafariServices
import TwitterKit
import Firebase
import SVProgressHUD

final class OnboardViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftyOnboard.style = .light
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        swiftyOnboard.backgroundColor = UIColor.orange
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 3, animated: true)
    }
    
    @objc func didTapPageControl(_ sender: Any) {
        let pager = sender as! UIPageControl
        let page = pager.currentPage
        swiftyOnboard?.goToPage(index: page, animated: true)
    }
    
//    @objc func handleSignUp(sender: UIButton) {
//        Firebase.User.signIn({
//            DispatchQueue.main.async {
//                AppDelegate.shared.rootViewController.switchToMainScreen()
//            }
//        })
//    }
}

extension OnboardViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 4
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        view?.image.image = UIImage(named: "onBoard\(index + 1)")
        if index == 0 {
            view?.titleLabel.text = "YOLO"
            view?.subTitleLabel.text = "YOLOはあなたの今までを\n１つのストーリーに\n綴っていくアプリです"
        } else if index == 1 {
            view?.titleLabel.text = "SNSを\nストーリーに"
            view?.subTitleLabel.text = "連携したSNSの投稿が\n自然に貯まっていきます"
        } else if index == 2 {
            view?.titleLabel.text = "一緒に\nストーリーに"
            view?.subTitleLabel.text = "一緒に体験していた友達と\n思い出を共有できます"
        } else {
            view?.titleLabel.text = "ここだけの\nストーリーに"
            view?.subTitleLabel.text = "みんなには見せれない...\nそんな思い出も残せます"
        }
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.pathButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
//        overlay?.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        overlay?.pagesControl.addTarget(self, action: #selector(didTapPageControl), for: .allTouchEvents)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.pagesControl.currentPage = Int(currentPage)
        if currentPage == 0.0 || currentPage == 1.0 || currentPage == 2.0 {
            overlay.configure()
        } else {
            overlay.lastPageConfigure()
        }
    }
}

extension OnboardViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}
