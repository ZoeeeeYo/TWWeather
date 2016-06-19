//
//  Sport.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

class Sport: NSObject {
    static let KeySportId = "_sportID"
    static let KeySportDes = "_description"
    
    private(set) var sportId: String
    private(set) var sportDes: String
    
    init(sportId: String, sportDes: String) {
        self.sportId = sportId
        self.sportDes = sportDes
    }
    
    static func fromJSON(json: [String: AnyObject]) -> Sport? {
        guard let sportId = json[KeySportId] as? String,
            sportDes = json[KeySportDes] as? String
            else { return nil }
        return Sport(sportId: sportId, sportDes: sportDes)
    }
}