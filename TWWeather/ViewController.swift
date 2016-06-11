//
//  ViewController.swift
//  TWWeather
//
//  Created by Zoe on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url: String = "http://dnu5embx6omws.cloudfront.net/venues/weather.json"
        let _ = try? NetworkManager.loadVenuesFromUrl(url) { venueArray in
            print(venueArray?.count)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

