//
//  Currency.swift
//  Currency
//
//  Created by Dante Solorio on 1/8/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import Foundation

struct Currency {
    var base: String?
    var date: String?
    var rates: [Rate]?
}
    
struct Rate {
    var rateName: String?
    var value: Float?
    var image: String?
}


// This enum couldn't be use it with this version of API, because rates isn't an array.

enum RateType: String {
    case AUD = "AUD"
    case BGN
    case BRL
    case CAD
    case CHF
    case CNY
    case CZK
    case DKK
    case GBP
    case HKD
    case HRK
    case HUF
    case IDR
    case ILS
    case INR
    case JPY
    case KRW
    case MXN
    case MYR
    case NOK
    case NZD
    case PHP
    case PLN
    case RON
    case RUB
    case SEK
    case SGD
    case THB
    case TRY
    case ZAR
    case EUR
}
