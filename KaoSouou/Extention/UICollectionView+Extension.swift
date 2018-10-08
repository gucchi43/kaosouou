//
//  UICollectionView+Extension.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/02/19.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: Nibable {
        register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with cellType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    public func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return className
    }
}
