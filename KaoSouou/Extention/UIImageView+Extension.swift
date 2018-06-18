//
//  UIImageView+Extension.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/16.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Pring
import FontAwesome_swift

extension UIImageView {
    func loadUserImageView(with user: User) {
        self.kf.indicatorType = .activity
        var loadUrl: URL?
        if let photoFile = user.photoFile {
            loadUrl = photoFile.downloadURL
            self.kf.setImage(with: loadUrl, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                print("\(receivedSize)/\(totalSize)")
            }) { (image, error, cacheType, imageURL) in
                if let imageURL = imageURL {
                    print("\(imageURL): Finished")
                } else {
                    self.setErrorImage()
                }
            }
        } else {
            self.setErrorImage()
        }
    }
    
    func loadUrlImageView(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
            print("\(receivedSize)/\(totalSize)")
        }) { (image, error, cacheType, imageURL) in
            if let imageURL = imageURL {
                print("\(imageURL): Finished")
            } else {
                self.setErrorImage()
            }
        }
    }

    func setErrorImage() {
        let size = CGSize(width: self.frame.size.height / 3, height: self.frame.size.height / 3)
        let errorImage = UIImage.fontAwesomeIcon(name: .photo, textColor: UIColor.white, size: size)
        self.image = errorImage
    }
    
    func setEmptyUserImage() {
        let size = CGSize(width: self.frame.size.height / 3, height: self.frame.size.height / 3)
        let errorImage = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.white, size: size)
        self.image = errorImage
    }
}

