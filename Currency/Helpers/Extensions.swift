//
//  Extensions.swift
//  Currency
//
//  Created by Dante Solorio on 1/9/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import UIKit

//
//  The following extension allows a String literal to return the localized version of
//  itself.
//
extension String {
    func localize() -> String! {
        return NSLocalizedString(self, comment: "")
    }
}

//
//  The following extension allows a View get bottom border
//
extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
