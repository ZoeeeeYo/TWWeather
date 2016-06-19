//
//  NSString+Text.swift
//  TWWeather
//
//  Created by Tingting Wen on 19/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

extension NSString {
    static var RequestUrl: String {
        return "http://dnu5embx6omws.cloudfront.net/venues/weather.json"
    }
    
    static var NotAvailableShort: String {
        return "N/A"
    }
    
    static var FeelLikeLabel: String {
        return "Feel like: "
    }
    
    static var LastUpdatedLabelName: String {
        return "Last updated: "
    }

    static var TemperatureUnitCelsius: String {
        return "°C"
    }
    
    static var VenueTableNoDataMessage: String {
        return "No data available. \n Please pull down to refresh, \n or change filter condition"
    }
    
    static var SearchTableNoDataMessage: String {
        return "No data available. \n \n Please use other keywords."
    }
}
