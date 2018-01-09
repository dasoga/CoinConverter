//
//  Currency.swift
//  Currency
//
//  Created by Dante Solorio on 1/8/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import Foundation

struct Currency: Decodable {
    var base: String?
    var date: String?
    var rates: Rate?
}
    
struct Rate: Decodable {
    var AUD: Float?
    var BGN: Float?
    var BRL: Float?
    var CAD: Float?
    var CHF: Float?
    var CNY: Float?
    var CZK: Float?
    var DKK: Float?
    var GBP: Float?
    var HKD: Float?
    var HRK: Float?
    var HUF: Float?
    var IDR: Float?
    var ILS: Float?
    var INR: Float?
    var JPY: Float?
    var KRW: Float?
    var MXN: Float?
    var MYR: Float?
    var NOK: Float?
    var NZD: Float?
    var PHP: Float?
    var PLN: Float?
    var RON: Float?
    var RUB: Float?
    var SEK: Float?
    var SGD: Float?
    var THB: Float?
    var TRY: Float?
    var ZAR: Float?
    var EUR: Float?
}
