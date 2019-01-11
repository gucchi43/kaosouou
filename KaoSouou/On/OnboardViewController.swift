//
//  ViewController.swift
//  OnboradSet
//
//  Created by Hiroki Taniguchi on 2018/02/17.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import SwiftyOnboard
import TTTAttributedLabel


class OnboardViewController: UIViewController {
    
    var fromAppHelp = false

    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    let titleArray = ["ワクワク", "プルルンッ", "ドクン、ドクン", "ズキュウゥゥン"]
    let boyTextArray = ["表示される異性を\n好きな顔の順にタップしよう",
                        "お、誰かが君を\nタップしたようだね\n今すぐ結果をチェックしよう",
                        "バトル結果がわかるよ\nメンタルブレイクに気をつけてね",
                        "バトルを繰り返すことで\n点数がどんどん正確になっていくよ\n君の顔は何点かな？"]
    let girlTextArray = ["表示される異性を\n好きな顔の順にタップしよう",
                         "お、誰かが君を\nタップしたようだね\n今すぐ結果をチェックしよう",
                         "バトル結果がわかるよ\nメンタルブレイクに気をつけてね",
                         "バトルを繰り返すことで\n点数がどんどん正確になっていくよ\n君の顔は何点かな？"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swiftyOnboard.style = .light
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        swiftyOnboard.backgroundColor = UIColor.black
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 4, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        if index == 4 {
            if fromAppHelp {
                self.dismiss(animated: true, completion: nil)
            } else {
                // 本番はこっちへ
                AppDelegate.shared.rootViewController.showMainScreen()
                // テスト用
                //            AppDelegate.shared.rootViewController.showLoginScreen()
            }
            fromAppHelp = false
        } else {
            swiftyOnboard?.goToPage(index: index + 1, animated: true)
        }
    }
}

extension OnboardViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 5
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        
        if index == 0 {
            let view = CustomFirstView.instanceFromNib() as? CustomFirstView
            return view
        } else {
            let view = CustomPage.instanceFromNib() as? CustomPage
            var selectColor: UIColor!
            var selectTextArray: [String]!
            var imageKey: String!
            if let currentUser = AccountManager.shared.currentUser {
                if currentUser.gender == 2{
                    selectColor = UIColor.girlBrandColor()
                    selectTextArray = girlTextArray
                    imageKey = "tg"
                } else {
                    selectColor = UIColor.boyBrandColor()
                    selectTextArray = boyTextArray
                    imageKey = "tm"
                }
            } else {
                selectColor = UIColor.girlBrandColor()
                selectTextArray = girlTextArray
                imageKey = "tg"
            }
            view?.titleLabel.adjustsFontSizeToFitWidth = true
            view?.neonBarView.layer.borderWidth = 1
            view?.neonBarView.backgroundColor = selectColor
            view?.neonBarView.layer.borderColor = selectColor.cgColor
            view?.neonBarView.viewShadow(radius: 0.5, opacity: 0.5, color: selectColor)
            
            view?.image.image = UIImage(named: imageKey + String(index - 1))
            view?.titleLabel.text = titleArray[index - 1]
            view?.subTitleLabel.text = selectTextArray[index - 1]
            return view
        }
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.contentControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 {
            overlay.buttonContinue.setTitle("使い方へ", for: .normal)
            overlay.skip.setTitle("Skip", for: .normal)
            overlay.skip.isHidden = false
        } else if currentPage == 1.0 || currentPage == 2.0 || currentPage == 3.0{
            overlay.buttonContinue.setTitle("次へ", for: .normal)
            overlay.skip.setTitle("Skip", for: .normal)
            overlay.skip.isHidden = false
        } else {
            overlay.buttonContinue.setTitle("OK！！！", for: .normal)
            overlay.skip.isHidden = true
        }
    }
}
