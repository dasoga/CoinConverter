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
    
    func fetchLatest(_ completion: @escaping (Currency) -> ()){
        fetchFeedForUrlString("\(baseUrl)/latest?base=USD") { (currency) in
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
                let json = try JSONDecoder().decode(Currency.self, from: data)
                completion(json)
            }catch let jsonErr {
                print(jsonErr)
                completion(nil)
            }
            
            }.resume()
        
    }
}
