//
//  ApiService.swift
//  Currency
//
//  Created by Dante Solorio on 1/8/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import Foundation

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://api.fixer.io"
    
    func fetchLatest(baseCoin: String ,_ completion: @escaping (Currency) -> ()){
        fetchFeedForUrlString("\(baseUrl)/latest?base=\(baseCoin)") { (currency) in
            if let currency = currency{
                completion(currency)
            }
        }
    }
    
    func fetchFromDate(date: String, baseCoin: String ,_ completion: @escaping (Currency) -> ()){
        fetchFeedForUrlString("\(baseUrl)/\(date)?base=\(baseCoin)") { (currency) in
            if let currency = currency{
                completion(currency)
            }
        }
    }

    
    func fetchFeedForUrlString(_ urlString:String, completion: @escaping (Currency?) -> ()){
        let url = URL(string: urlString)        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            //Success
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]{
                    var currency = Currency()
                    currency.base = json[Constants.BASE_KEY] as? String
                    currency.date = json[Constants.DATE_KEY] as? String
                    let ratesDic = json[Constants.RATES_KEY] as? [String: Any]
                    
                    var rate = Rate()
                    var ratesToSave = [Rate]()
                    guard let rates = ratesDic else { return }
                    for singleRate in rates{
                        rate.rateName = singleRate.key
                        rate.image = singleRate.key
                        rate.value = singleRate.value as? Double
                        ratesToSave.append(rate)
                    }                    
                    currency.rates = ratesToSave
                    completion(currency)
                }
            }catch let jsonErr {
                print(jsonErr)
                completion(nil)
            }
            
            }.resume()
        
    }
}
