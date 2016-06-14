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
        navigationItem.title = venue.venueName + "/" + venue.country.name
        view.sendSubviewToBack(weatherIcon)
        view.backgroundColor = UIColor.init(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.00)
        
        if let date = venue.lastUpdated {
//            dateLabel.text = date.getElapsedInterval()
            lastUpdateLabel.text = date.toDateString
        } else {
            lastUpdateLabel.text = VenuesTableViewCell.NotAvailable
        }
        
        if let con = venue.weatherCondition {
            weatherConditionLabel.text = con.rawValue
        } else {
            weatherConditionLabel.text = VenuesTableViewCell.NotAvailable
        }
        
        if let tem = venue.temperature {
            temperatureLabel.text = "\(Int(tem))"
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
    
    @IBAction func backButtonPressed() {
        navigationController!.popViewControllerAnimated(true)
    }

}
