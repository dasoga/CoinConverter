//
//  ViewController.swift
//  Currency
//
//  Created by Dante Solorio on 1/8/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrency()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getCurrency(){
        ApiService.sharedInstance.fetchLatest { (currency) in
            print(currency.base)
            print(currency.date)
            for rate in currency.rates!{
                print(rate.rateName,rate.value)
            }
        }
    }

}

