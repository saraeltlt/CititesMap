//
//  CityCell.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var mapImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(cityName: String, data: Data?) {
        cityNameLabel.text = cityName
        // set image or placeholder
        if let data = data,
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.mapImageView.image = image
            }
        } else {
            self.mapImageView.image = Constants.Images.globeImage
        }
        
    }
}
