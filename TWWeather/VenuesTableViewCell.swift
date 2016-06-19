//
//  VenuesTableViewCell.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit


class VenuesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    func updateCell(venue: Venue) {
        self.venueLabel.text = venue.venueName
        self.countryLabel.text = venue.country.name
        
        if let tem = venue.temperature {
            temperatureLabel.text = "\(Int(tem))" + NSString.TemperatureUnitCelsius
        } else {
            temperatureLabel.text = NSString.NotAvailableShort
        }
        
        if let date = venue.lastUpdated {
            dateLabel.text = date.toDateString
        } else {
            dateLabel.text = NSString.NotAvailableShort
        }
        
        if let condition = venue.weatherCondition {
            weatherIconImage.image = UIImage(named: condition.rawValue)
        } else {
            weatherIconImage.image = UIImage.notAvailableTabelCellIconImage
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
