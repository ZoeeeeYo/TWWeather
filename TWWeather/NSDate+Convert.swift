//
//  NSDate+Convert.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import Foundation

extension NSDate {
    
    func getElapsedInterval() -> String {
        
        var interval = NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year
        
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "year" :
                "\(interval)" + " " + "years"
        }
        
        interval = NSCalendar.currentCalendar().components(.Month, fromDate: self, toDate: NSDate(), options: []).month
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "month" :
                "\(interval)" + " " + "months"
        }
        
        interval = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).day
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "day" :
                "\(interval)" + " " + "days"
        }
        
        interval = NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: NSDate(), options: []).hour
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour" :
                "\(interval)" + " " + "hours"
        }
        
        interval = NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: NSDate(), options: []).minute
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "minute" :
                "\(interval)" + " " + "minutes"
        }
        
        interval = NSCalendar.currentCalendar().components(.Second, fromDate: self, toDate: NSDate(), options: []).second
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "second" :
                "\(interval)" + " " + "seconds"
        }
        
        return "a moment"
    }
    
    var toDateString: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/YYYY"
        return formatter.stringFromDate(self)
    }
}

