//
//  RootViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/13.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    var current: UIViewController
    
    init() {
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! SplashViewController
        current = viewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(current)
        view.addSubview(current.view)
        current.didMove(toParentViewController: self)
    }
    
    func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let new = storyboard.instantiateInitialViewController() as! LoginViewController
        addChildViewController(new)
        view.addSubview(new.view)
        new.didMove(toParentViewController: self)
        
        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current = new
    }
    
    func showMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let new = storyboard.instantiateInitialViewController() as! ViewController
        addChildViewController(new)
        view.addSubview(new.view)
        new.didMove(toParentViewController: self)
        
        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current = new
    }
    
    func showOnboardScreen() {
        let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
        let new = storyboard.instantiateInitialViewController() as! OnboardViewController
        addChildViewController(new)
        view.addSubview(new.view)
        new.didMove(toParentViewController: self)
        
        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current = new
    }
    
    func switchToLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! LoginViewController
        animateFadeTransition(to: viewController)
    }
    
    func switchToSetProfile(with photoUrl: URL?) {
        let storyboard = UIStoryboard(name: "SetProfile", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! SetProfileViewController
        viewController.currentType = .initial
        if let photoUrl = photoUrl {
            viewController.photoUrl = photoUrl
        }
        animateFadeTransition(to: viewController)
    }
    
    func switchToGenderSelect() {
        let storyboard = UIStoryboard(name: "GenderSelect", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! GenderSelectViewController
        animateFadeTransition(to: viewController)
    }
    
    func switchToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! ViewController
        animateFadeTransition(to: viewController)
    }
    
    func switchToOnboardScreen() {
        let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! OnboardViewController
        animateFadeTransition(to: viewController)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParentViewController: nil)
        addChildViewController(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { completed in
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?()
        }
    }
}

