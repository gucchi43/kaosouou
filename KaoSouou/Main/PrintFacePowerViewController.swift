//
//  PrintFacePowerViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/02/19.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Kingfisher
import Pring
import FontAwesome_swift

class PrintFacePowerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstUserImageView: UIImageView!
    @IBOutlet weak var SecondUserImageView: UIImageView!
    @IBOutlet weak var ThirdUserImageView: UIImageView!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var faceImage: UIImage?
    var faceImageUrl: URL?
    var dataSourse: DataSource<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        imageView.image = faceImage
        getLoveUsers()
        powerLabel.text = "So cu~~~te!!!"
        
    }
    
    func getLoveUsers() {
        guard let user = AccountManager.shared.currentUser else { return }
        
        dataSourse = user.loveUsers
            .order(by: \User.updatedAt)
            .limit(to: 4)
            .dataSource()
            .onCompleted({ (snapshot, users) in
                self.setUsersImage(users: users)
            })
        .listen()
    }
    
    func setButton() {
        nextButton.layer.cornerRadius = nextButton.bounds.height / 2
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.white.cgColor
        nextButton.clipsToBounds = true
    }
    
    func setUsersImage(users: [User]) {
        if let user = users[safe: 0] {
            firstUserImageView.loadUserImageView(with: user)
        } else {
            firstUserImageView.setEmptyUserImage()
        }
        if let user = users[safe: 1] {
            SecondUserImageView.loadUserImageView(with: user)
        } else {
            SecondUserImageView.setEmptyUserImage()
        }
        if let user = users[safe: 2] {
            ThirdUserImageView.loadUserImageView(with: user)
        } else {
            ThirdUserImageView.setEmptyUserImage()
        }
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
