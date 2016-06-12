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
    @IBOutlet weak var temeratureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    
    func updateCell(venue: Venue) {
       self.venueLabel.text = venue.venueName
        
        if let tem = venue.temperature {
            temeratureLabel.text = "\(tem)" + VenuesTableViewCell.TemUnit
        } else {
            temeratureLabel.text = VenuesTableViewCell.NotAvailable
        }
        
        if let date = venue.lastUpdated {
            dateLabel.text = date.getElapsedInterval()
        } else {
            dateLabel.text = VenuesTableViewCell.NotAvailable
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
