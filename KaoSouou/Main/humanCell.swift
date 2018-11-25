//
//  humanCell.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/02/19.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit

class humanCell: UICollectionViewCell, Nibable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numLabel.isHidden = true
        numLabel.lblShadow(radius: 3, opacity: 0.25)
        numLabel.textColor = UIColor.white

    }
    
    func configure(with user: User, num: Int) {
        imageView.loadUserImageView(with: user)
        if num == 0 {
            numLabel.isHidden = true
        } else {
            numLabel.isHidden = false
            numLabel.text = String(num)
        }
        
    }
    
    func configure(with image: UIImage, num: Int) {
        imageView.image = image
        if num == 0 {
            numLabel.isHidden = true
        } else {
            numLabel.isHidden = false
            numLabel.text = String(num)
        }
    }
    
    func emptyConfigure() {
        numLabel.text = ""
        imageView.image = nil
        imageView.backgroundColor = UIColor.black
    }
    
    func check(with num: Int) {
        numLabel.text = String(num)
        numLabel.isHidden = false
//        isUserInteractionEnabled = false
        
    }
    
    func uncheck() {
        numLabel.text = ""
        numLabel.isHidden = true
//        isUserInteractionEnabled = true
    }
}

