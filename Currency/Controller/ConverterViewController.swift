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
        tf.keyboardType = .decimalPad
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
        label.font = UIFont.systemFont(ofSize: 36)
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
    
    lazy var dateTextField: UITextField = {
        let tf = UITextField()
        tf.text = Constants.CHANGE_RATE_DATE_TEXT
        tf.textAlignment = .center
        tf.delegate = self
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
        self.title = Constants.HOME_TITLTE_CONTROLLER
        view.backgroundColor = .white
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupNavBar()
        
        // Add input text field and its constraints
        view.addSubview(sourceCurrencyTextField)
        sourceCurrencyTextField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        sourceCurrencyTextField.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        sourceCurrencyTextField.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        sourceCurrencyTextField.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
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
        targetCurrencyLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // Add target currency button and constraints
        view.addSubview(targetCurrencyButton)
        targetCurrencyButton.topAnchor.constraint(equalTo: targetCurrencyLabel.bottomAnchor, constant: 8).isActive = true
        targetCurrencyButton.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        targetCurrencyButton.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        targetCurrencyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Button label of updated
        view.addSubview(lastUpdateLabel)
        lastUpdateLabel.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        lastUpdateLabel.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        lastUpdateLabel.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        lastUpdateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Add date textfield
        view.addSubview(dateTextField)
        dateTextField.bottomAnchor.constraint(equalTo: lastUpdateLabel.topAnchor, constant: -30).isActive = true
        dateTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        dateTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getCurrencyData(baseCoin: String){
        ApiService.sharedInstance.fetchLatest(baseCoin: baseCoin) { (currency) in
            self.manageData(currency: currency)
        }
    }
    
    private func getCurrencyDataFromDate(date: String){
        var baseCoin = Constants.BASE_COIN
        if let sourceName = sourceCurrency?.rateName{
            baseCoin = sourceName
        }
        ApiService.sharedInstance.fetchFromDate(date: date, baseCoin: baseCoin) { (currency) in
            self.manageData(currency: currency)
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    private func manageData(currency: Currency){
        self.actualCurrency = currency
        
        // Build rates list
        guard let allRates = self.actualCurrency.rates else { return }
        self.allRates = allRates
        
        // Assign default target
        if self.targetCurrency == nil{
            self.targetCurrency = allRates[0]
        }else{
            guard let actualTargetCurrency = self.targetCurrency else { return }
            let targets = allRates.filter { $0.rateName == actualTargetCurrency.rateName }
            if let firstTargetExist = targets.first{
                self.targetCurrency = firstTargetExist
            }else{
                self.targetCurrency = allRates[0]
            }
        }
        
        // Update label of last update
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Constants.FORMAT_DATE
        // Return to main thread to update UI
        DispatchQueue.main.async {
            self.lastUpdateLabel.text = "Last update: \(dateFormatterPrint.string(from: Date()))"
            guard let imageName = self.targetCurrency?.rateName else { return }
            self.targetCurrencyButton.setImage(UIImage(named: imageName), for: .normal)
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
    
    private func calculateRate(text: String){
        if let doubleValue = Double(text) {
            guard let targetValue = targetCurrency?.value, let targetName = targetCurrency?.rateName else { return }
            let result = doubleValue * targetValue
            targetCurrencyLabel.text = "$ " + String(result) + " " + targetName
        }else{
            targetCurrencyLabel.text = Constants.ZERO_VALUE_MONEY
        }
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let textValue = textField.text else { return }
        calculateRate(text: textValue)
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
    
    @objc private func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let stringDate = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDateToFind = dateFormatter.string(from: sender.date)
        
        dateTextField.text = stringDate
        lastUpdateLabel.isHidden = true
        getCurrencyDataFromDate(date: stringDateToFind)
    }
    
    @objc private func doneAction(sender: UIBarButtonItem){
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
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
        dateTextField.text = Constants.CHANGE_RATE_DATE_TEXT
        lastUpdateLabel.isHidden = false
        self.updateView()
    }
}


extension ConverterViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        let calendar = Calendar.current
        var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day = 04
        minDateComponent.month = 01
        minDateComponent.year = 1999
        let minDate = calendar.date(from: minDateComponent)
        datePickerView.minimumDate = minDate
        dateTextField.inputView = datePickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".localize(), style: .plain, target: self, action: #selector(doneAction))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
}
