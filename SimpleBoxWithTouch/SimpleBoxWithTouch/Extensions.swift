//
//  Extensions.swift
//  SimpleBoxWithTouch
//
//  Created by 박세은 on 2018. 11. 21..
//  Copyright © 2018년 박세은. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor{
    static func random() -> UIColor {
        return UIColor(red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 1.0)
    }
}
