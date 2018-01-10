//
//  ConverterViewController.swift
//  Currency
//
//  Created by Dante Solorio on 1/9/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {
    
    lazy var sourceCurrencyTextField: UITextField = {
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
        button.addTarget(self, action: #selector(actionCurrencyButton), for: .touchUpInside)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let targetCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.ZERO_VALUE_MONEY
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let targetCurrencyButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(actionCurrencyButton), for: .touchUpInside)
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.text = "Last update: ".localize()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var actualCurrency = Currency()
    
    var allRates = [Rate]()
    
    var sourceCurrency: Rate?
    var targetCurrency: Rate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCurrencyData(baseCoin: Constants.BASE_COIN)
    }
    
    private func setupView(){
        self.title = "Currency converter"
        
        view.backgroundColor = .white
        
        view.addSubview(lastUpdateLabel)
        lastUpdateLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lastUpdateLabel.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        lastUpdateLabel.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        lastUpdateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Add input text field and its constraints
        view.addSubview(sourceCurrencyTextField)
        sourceCurrencyTextField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: lastUpdateLabel.bottomAnchor, constant: 16).isActive = true
        sourceCurrencyTextField.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        sourceCurrencyTextField.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        sourceCurrencyTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add source currency button and constraints
        view.addSubview(sourceCurrencyButton)
        sourceCurrencyButton.topAnchor.constraint(equalTo: sourceCurrencyTextField.bottomAnchor, constant: 8).isActive = true
        sourceCurrencyButton.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        sourceCurrencyButton.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        sourceCurrencyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Add result label and its constraints
        view.addSubview(targetCurrencyLabel)
        targetCurrencyLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: sourceCurrencyButton.bottomAnchor, constant: 8).isActive = true
        targetCurrencyLabel.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        targetCurrencyLabel.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        targetCurrencyLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add target currency button and constraints
        view.addSubview(targetCurrencyButton)
        targetCurrencyButton.topAnchor.constraint(equalTo: targetCurrencyLabel.bottomAnchor, constant: 8).isActive = true
        targetCurrencyButton.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        targetCurrencyButton.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        targetCurrencyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func getCurrencyData(baseCoin: String){
        ApiService.sharedInstance.fetchLatest(baseCoin: baseCoin) { (currency) in
            self.actualCurrency = currency
            
            // Update label of last update
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = Constants.FORMAT_DATE
            
            // Build rates list
            guard let allRates = self.actualCurrency.rates else { return }
            self.allRates = allRates
            
            // Assign default target
            if self.targetCurrency == nil{
                self.targetCurrency = allRates[0]
            }else{
                guard let actualTargetCurrency = self.targetCurrency else { return }
                let targets = allRates.filter { $0.rateName == actualTargetCurrency.rateName }
                self.targetCurrency = targets.first
            }
            
            DispatchQueue.main.async {
                self.lastUpdateLabel.text = "Last update: \(dateFormatterPrint.string(from: Date()))"
                guard let imageName = self.targetCurrency?.rateName else { return }
                self.targetCurrencyButton.setImage(UIImage(named: imageName), for: .normal)
            }
        }
    }
    
    private func updateView(){
        if let sourceName = sourceCurrency?.rateName{
            sourceCurrencyButton.setImage(UIImage(named: sourceName), for: .normal)
            sourceCurrencyTextField.placeholder = "$1 \(sourceName)"
        }
        
        if let targetName = targetCurrency?.rateName{
            targetCurrencyButton.setImage(UIImage(named: targetName), for: .normal)
        }
        sourceCurrencyTextField.text = ""
        targetCurrencyLabel.text = Constants.ZERO_VALUE_MONEY
        
    }
    
    // MARK: - Actions
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let textValue = textField.text else { return }
        if let doubleValue = Double(textValue) {
            guard let targetValue = targetCurrency?.value, let targetName = targetCurrency?.rateName else { return }
            let result = doubleValue * targetValue
            targetCurrencyLabel.text = String(result) + " " + targetName
        }else{
            targetCurrencyLabel.text = Constants.ZERO_VALUE_MONEY
        }
        
    }
    
    @objc private func actionCurrencyButton(_ button: UIButton){
        let totalCurrenciesController = TotalCurrenciesTableViewController()
        totalCurrenciesController.allCurrenciesToShow = allRates
        totalCurrenciesController.delegate = self
        totalCurrenciesController.buttonType = .source
        if button == targetCurrencyButton{
            totalCurrenciesController.buttonType = .target
        }
        navigationController?.pushViewController(totalCurrenciesController, animated: true)
    }

}

extension ConverterViewController: CurrencySelectedDelegate{
    func didSelectedCurrency(rateSelected: Rate, buttonType: CurrencyButtonType) {
        if buttonType == .source{
            sourceCurrency = rateSelected
            guard let rateName = rateSelected.rateName else { return }
            getCurrencyData(baseCoin: rateName)
        }else{
            targetCurrency = rateSelected
        }
        self.updateView()
    }
}
