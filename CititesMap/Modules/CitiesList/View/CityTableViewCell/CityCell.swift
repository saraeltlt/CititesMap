//
//  CityCell.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet private weak var cityNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(cityName: String) {
        cityNameLabel.text = cityName
    }
    
}
