//
//  NotificationTableViewCell.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/20.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell, Nibable {

    @IBOutlet weak var voderImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var agoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        voderImageView.setEmptyUserImage()
        voderImageView.layer.cornerRadius = voderImageView.bounds.width / 2
        voderImageView.clipsToBounds = true
    }
    
    func configure(with notificationItem: NotificationItem) {
        messageLabel.text = String(notificationItem.num) + "位に選ばれました"
        agoLabel.text = notificationItem.createdAt.convertAgoText()
        notificationItem.from.get { (fromUser, error) in
            if let fromUser = fromUser {
                self.voderImageView.loadUserImageView(with: fromUser)
            } else {
                self.voderImageView.setEmptyUserImage()
            }
        }
    }
    
}
