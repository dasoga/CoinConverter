//
//  Extensions.swift
//  Currency
//
//  Created by Dante Solorio on 1/9/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import Foundation

//
//  The following extension allows a String literal to return the localized version of
//  itself.
//
extension String {
    func localize() -> String! {
        return NSLocalizedString(self, comment: "")
    }
}
