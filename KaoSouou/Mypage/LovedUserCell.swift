//
//  LovedUserCell.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/09/21.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit

class LovedUserCell: UICollectionViewCell, Nibable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with user: User?) {
        guard  let user = user else { return }
        imageView.loadUserImageView(with: user)
        userNameLabel.text = user.displayName
        pointLabel.text = String(user.hensachi.shisyagonyu())
    }
    
}
