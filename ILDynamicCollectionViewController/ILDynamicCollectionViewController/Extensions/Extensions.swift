//
//  Extensions.swift
//  ILDynamicCollectionViewController
//
//  Created by Igar Liubavetskiy on 2017-07-30.
//  Copyright © 2017 Igar Liubavetskiy. All rights reserved.
//

import UIKit

extension Int {
    
    static func random(from: Int, to end: Int) -> Int {
        var a = from
        var b = end
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
