//
//  RateTableViewCell.swift
//  Currency
//
//  Created by Dante Solorio on 1/9/18.
//  Copyright © 2018 Dante Solorio. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {
    
    let flagImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "USD")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let rateNameLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.BASE_COIN
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var actualRate: Rate? {
        didSet{
            setupData()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Function to setup the view of the cell
    */
    private func setupView(){
        // Add constatins to flag image view
        addSubview(flagImageView)
        flagImageView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        flagImageView.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        flagImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        flagImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add constatins to rate name
        addSubview(rateNameLabel)
        rateNameLabel.leftAnchor.constraint(equalTo: flagImageView.rightAnchor, constant: 8).isActive = true
        rateNameLabel.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        rateNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rateNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupData(){
        guard let name = actualRate?.rateName else { return }
        flagImageView.image = UIImage(named: name)
        rateNameLabel.text = name
    }

}
