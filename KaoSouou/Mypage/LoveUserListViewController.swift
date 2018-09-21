//
//  LoveUserListViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/09/20.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Kingfisher
import Pring
import Firebase
import SVProgressHUD

class LoveUserListViewController: UIViewController {

//    var kaoUserArray: [User] = []
    var userDataSourse: DataSource<User>?
    
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(LovedUserCell.self)
        guard let currentUser = AccountManager.shared.currentUser else { return }
        getUserArray(with: currentUser)
    }
    
    func getUserArray(with user: User) {
//        kaoUserArray.removeAll()
        userDataSourse = user
            .loveUsers
            .order(by: \User.updatedAt)
            .dataSource()
            .on({ [weak self] (snapshot, changes) in
                guard let collectionView: UICollectionView = self?.collectionView else { return }
                switch changes {
                case .initial:
                    collectionView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    collectionView.reloadData()
                case .error(let error):
                    print(error)
                }
            }).listen()
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        dismiss(animated: true) {
            print("close loveList")
        }
    }
    
}


extension LoveUserListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard  let userDataSourse = userDataSourse else { return 0 }
        
        print("userDataSourse.count : ", userDataSourse.count)
        
        return userDataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: LovedUserCell.self, for: indexPath)
        cell.configure(with: userDataSourse![indexPath.row])
        return cell
    }
}

extension LoveUserListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space = 1
        let wlength = (Int(UIScreen.main.bounds.width) - space) / 2
        let hlength = (Int(UIScreen.main.bounds.height) - space) / 2
        
        return CGSize(width: wlength, height: hlength)
    }
}


extension LoveUserListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("indexPath.row : ", indexPath.row)
        
        let cell = collectionView.cellForItem(at: indexPath) as! LovedUserCell
        // ??? 何する？ とりあえず写真を全画面表示する
        
    }
}
