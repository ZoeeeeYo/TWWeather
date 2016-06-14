//
//  VenuesTableViewCell.swift
//  TWWeather
//
//  Created by Zoe on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit


class VenuesTableViewCell: UITableViewCell {
    static let NotAvailable = "N/A"
    static let TemUnit = "°C"
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    func updateCell(venue: Venue) {
        self.venueLabel.text = venue.venueName
        self.countryLabel.text = venue.country.name
        
        if let tem = venue.temperature {
            temperatureLabel.text = "\(Int(tem))" + VenuesTableViewCell.TemUnit
        } else {
            temperatureLabel.text = VenuesTableViewCell.NotAvailable
        }
        
        if let date = venue.lastUpdated {
//            dateLabel.text = date.getElapsedInterval()
            dateLabel.text = date.toDateString
        } else {
            dateLabel.text = VenuesTableViewCell.NotAvailable
        }
    }

    override func awakeFromNib() {
//        self.selectionStyle = 
        self.selectedBackgroundView?.backgroundColor = UIColor.init(red: 0.890, green: 0.949, blue: 0.988, alpha: 1.00)
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
