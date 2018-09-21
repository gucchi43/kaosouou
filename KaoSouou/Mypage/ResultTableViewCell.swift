//
//  ResultTableViewCell.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/21.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell, Nibable {

    @IBOutlet weak var numlabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hensachiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.setEmptyUserImage()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func configure(with num: Int, user: User?) {
        numlabel.text = String(num)
        if let user = user {
            profileImageView.loadUserImageView(with: user)
            nameLabel.text = user.displayName
            hensachiLabel.text = String(user.hensachi.shisyagonyu())
        } else {
            profileImageView.setEmptyUserImage()
            nameLabel.text = "?????"
            hensachiLabel.text = "?????"
        }
    }
}
