//
//  Array+Extention.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/05/17.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
