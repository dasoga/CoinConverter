//
//  ConverterViewController.swift
//  Currency
//
//  Created by Dante Solorio on 1/9/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Constants.ONE_VALUE_MONEY
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let sourceCurrencyButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "USD"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let ammountConvertedLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.ZERO_VALUE_MONEY
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let targetCurrencyButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "USD"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let baseCoin = Constants.BASE_COIN
    
    var actualCurrency = Currency()
    
    var allRates = [Rate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCurrencyData()
    }
    
    private func setupView(){
        view.backgroundColor = .white
        
        // Add input text field and its constraints
        view.addSubview(inputTextField)
        inputTextField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        inputTextField.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        inputTextField.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add source currency button and constraints
        view.addSubview(sourceCurrencyButton)
        sourceCurrencyButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 8).isActive = true
        sourceCurrencyButton.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        sourceCurrencyButton.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        sourceCurrencyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Add result label and its constraints
        view.addSubview(ammountConvertedLabel)
        ammountConvertedLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: sourceCurrencyButton.bottomAnchor, constant: 8).isActive = true
        ammountConvertedLabel.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        ammountConvertedLabel.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        ammountConvertedLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add target currency button and constraints
        view.addSubview(targetCurrencyButton)
        targetCurrencyButton.topAnchor.constraint(equalTo: ammountConvertedLabel.bottomAnchor, constant: 8).isActive = true
        targetCurrencyButton.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        targetCurrencyButton.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        targetCurrencyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func getCurrencyData(){
        ApiService.sharedInstance.fetchLatest(baseCoin: baseCoin) { (currency) in
            self.actualCurrency = currency
            
            // Update label of last update
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = Constants.FORMAT_DATE
            DispatchQueue.main.async {
                self.title = dateFormatterPrint.string(from: Date())
            }
            
            // Build rates list
            guard let allRates = self.actualCurrency.rates else { return }
            self.allRates = allRates
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let textValue = textField.text else { return }
        if let doubleValue = Double(textValue) {
            let result = doubleValue*(self.actualCurrency.rates?[0].value)!
            ammountConvertedLabel.text = String(result)
        }else{
            ammountConvertedLabel.text = Constants.ZERO_VALUE_MONEY
        }
        
    }

}
