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
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var windView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navi bar title
        navigationItem.title = venue.venueName + "/" + venue.country.name
//        let backBarButton = UIBarButtonItem.init(image: UIImage.init(named: "BackButton"),
//                                                   style: UIBarButtonItemStyle.Done,
//                                                   target: self,
//                                                   action: #selector(backButtonPressed(_:)))
        let backBarButton = UIBarButtonItem.init(title: "Back",
                                                 style: UIBarButtonItemStyle.Done,
                                                 target: self,
                                                 action: #selector(backButtonPressed(_:)))
        backBarButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBarButton
        
        // Add tap gestures
        let tapWeatherView = UITapGestureRecognizer.init(target: self, action: #selector(weatherConditionViewTapped(_:)))
        weatherView.addGestureRecognizer(tapWeatherView)
        
        let tapTemperature = UITapGestureRecognizer.init(target: self, action: #selector(temperatureViewTapped(_:)))
        temperatureView.addGestureRecognizer(tapTemperature)
        
        let tapWind = UITapGestureRecognizer.init(target: self, action: #selector(windViewTapped(_:)))
        windView.addGestureRecognizer(tapWind)
        
        let tapHumidity = UITapGestureRecognizer.init(target: self, action: #selector(humidityViewTapped(_:)))
        humidityView.addGestureRecognizer(tapHumidity)
        
        
        // Config background colour
        view.sendSubviewToBack(weatherIcon)
        view.backgroundColor = UIColor.weatherDetailBackgroundColour
        weatherView.backgroundColor = UIColor.weatherDetailBackgroundColour
        temperatureView.backgroundColor = UIColor.weatherDetailBackgroundColour
        windView.backgroundColor = UIColor.weatherDetailBackgroundColour
        humidityView.backgroundColor = UIColor.weatherDetailBackgroundColour
        
        // Load view data
        updateViewForVenue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateViewForVenue() {
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
        
        if let feel = venue.feelLike {
            feelLikeLabel.text = "Feel like: " + "\(Int(feel))"
        } else {
            feelLikeLabel.text = "Feel like: " + VenuesTableViewCell.NotAvailable 
        }
        
        //weather icon
        if let condition = venue.weatherCondition {
            weatherIcon.image = UIImage(named: condition.rawValue)
        } else {
            weatherIcon.image = nil
        }
        
        // Wind and humidity
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
    
    
    /// MARK: - Add animations when views tapped
    func weatherConditionViewTapped(sender: UITapGestureRecognizer) {
        addScaleAnimationToView(weatherConditionLabel, fromValue: 1.0, toValue: 1.4, duration: 0.3)
    }
    
    func temperatureViewTapped(sender: UITapGestureRecognizer) {
        addScaleAnimationToView(temperatureLabel, fromValue: 1.0, toValue: 1.4, duration: 0.3)
    }
    
    func windViewTapped(sender: UITapGestureRecognizer) {
        addScaleAnimationToView(windLabel, fromValue: 1.0, toValue: 1.4, duration: 0.3)
    }
    
    func humidityViewTapped(sender: UITapGestureRecognizer) {
        addScaleAnimationToView(humidityLabel, fromValue: 1.0, toValue: 1.4, duration: 0.3)
    }
    
    private func addScaleAnimationToView(view: UIView, fromValue: Double, toValue: Double, duration: Double) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = fromValue
        scaleAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.toValue = toValue
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = 0
        scaleAnimation.autoreverses = true;
        scaleAnimation.removedOnCompletion = true;
        scaleAnimation.fillMode = kCAFillModeForwards;
        view.layer.addAnimation(scaleAnimation, forKey: "Float")
    }
    
    /// MARK: - IBactions
    func backButtonPressed(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }

}
