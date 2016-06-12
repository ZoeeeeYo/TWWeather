//
//  WeatherDetailViewController.swift
//  TWWeather
//
//  Created by Zoe on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var venue: Venue!
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.backGroundColour
        view.backgroundColor = UIColor.lightGrayColor()
        navigationItem.title = venue.venueName + "/" + venue.country.name
        
        if let date = venue.lastUpdated {
//            dateLabel.text = date.getElapsedInterval()
            lastUpdateLabel.text = date.toDateString
        } else {
            lastUpdateLabel.text = VenuesTableViewCell.NotAvailable
        }
        
        // TOCO: weather condition
        
        if let tem = venue.temperature {
            temperatureLabel.text = "\(tem)" + VenuesTableViewCell.TemUnit
        } else {
            temperatureLabel.text = VenuesTableViewCell.NotAvailable
        }
        
        //TODO: weather icon
        
        if let wind = venue.wind {
            windLabel.text = wind
        } else {
            windLabel.text = VenuesTableViewCell.NotAvailable
        }
        
        if let hum = venue.humidity {
            humidityLabel.text = hum
        } else {
            humidityLabel.text = VenuesTableViewCell.NotAvailable
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
