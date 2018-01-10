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
    var filterRates = [Rate]()
    
    var delegate: CurrencySelectedDelegate?
    
    var buttonType = CurrencyButtonType.source
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Private funcs
    
    private func setupView(){
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: Constants.RATE_CELL_IDENTIFIER)
        
        setupNavBar()
    }
    
    private func setupNavBar(){        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return filterRates.count
        }else{
            if let totalRates = allCurrenciesToShow?.count{
                return totalRates
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.RATE_CELL_IDENTIFIER, for: indexPath) as! RateTableViewCell
        if let all = allCurrenciesToShow {
            cell.actualRate =  all[indexPath.row]
            if searchController.isActive {
                cell.actualRate =  filterRates[indexPath.row]
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rateSelected = allCurrenciesToShow?[indexPath.row] else { return }
        var rate = rateSelected
        if searchController.isActive{
            rate = filterRates[indexPath.row]
            searchController.isActive = false
        }
        delegate?.didSelectedCurrency(rateSelected: rate, buttonType: buttonType)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension TotalCurrenciesTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let all = allCurrenciesToShow, let text = searchController.searchBar.text else { return }
        filterRates = all.filter { (rate: Rate) -> Bool in
            guard let rateName = rate.rateName else { return false }
            if rateName.lowercased().contains(text.lowercased()){
                return true
            }else{
                return false
            }
        }
        
        tableView.reloadData()
    }
}
