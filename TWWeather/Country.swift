//
//  Country.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

class Country: Hashable {
    static let KeyCountryId = "_countryID"
    static let KeyCountryName = "_name"
    
    private(set) var countryId: Int
    private(set) var name: String
    
    init(countryId: Int, name: String) {
        self.countryId = countryId
        self.name = name
    }
    
    static func fromJSON(json: [String: AnyObject]) -> Country? {
        guard let countryIdString = json[KeyCountryId] as? String,
            countryId = Int(countryIdString),
            name = json[KeyCountryName] as? String
            else { return nil }
        return Country(countryId: countryId, name: name)
    }
    
    var hashValue: Int {
        return countryId
    }
}

func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.countryId == rhs.countryId
}
