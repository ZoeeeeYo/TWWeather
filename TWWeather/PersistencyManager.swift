//
//  PersistencyManager.swift
//  TWWeather
//
//  Created by Tingting Wen on 16/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import Foundation

class PersistencyManager: NSObject {
    
    static let kLastUpdatedDate = "lastUpdated"
    
    static func storeLastUpdatedDate(date: NSDate) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(date, forKey: kLastUpdatedDate)
        userDefaults.synchronize()
    }
    
    static func getLastUpdatedDate() -> NSDate? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let lastUpdate = userDefaults.objectForKey(kLastUpdatedDate) as? NSDate
        if let date = lastUpdate{
            userDefaults.synchronize()
            return date
        } else {
            return nil
        }
    }
}
