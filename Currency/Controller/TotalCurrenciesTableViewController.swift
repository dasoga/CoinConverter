//
//  TotalCurrenciesTableViewController.swift
//  Currency
//
//  Created by Dante Solorio on 1/9/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import UIKit

enum CurrencyButtonType{
    case source
    case target
}

protocol CurrencySelectedDelegate {
    func didSelectedCurrency(rateSelected: Rate, buttonType: CurrencyButtonType)
}

class TotalCurrenciesTableViewController: UITableViewController {
    
    var allCurrenciesToShow: [Rate]?
    
    var delegate: CurrencySelectedDelegate?
    
    var buttonType = CurrencyButtonType.source

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Private funcs
    
    private func setupView(){
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: Constants.RATE_CELL_IDENTIFIER)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalRates = allCurrenciesToShow?.count{
            return totalRates
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let all = allCurrenciesToShow{
            cell.textLabel?.text = all[indexPath.row].rateName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rateSelected = allCurrenciesToShow?[indexPath.row] else { return }
        delegate?.didSelectedCurrency(rateSelected: rateSelected, buttonType: buttonType)
        navigationController?.popViewController(animated: true)
    }
}
