//
//  Country.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

class Country: NSObject {
    static let KeyCountryId = "_countryID"
    static let KeyCountryName = "_name"
    
    private(set) var countryId: String
    private(set) var name: String
    
    init(countryId: String, name: String) {
        self.countryId = countryId
        self.name = name
    }
    
    static func fromJSON(json: [String: AnyObject]) -> Country? {
        guard let countryId = json[KeyCountryId] as? String,
            name = json[KeyCountryName] as? String
            else { return nil }
        return Country(countryId: countryId, name: name)
    }
}
