//
//  NetworkManger.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

enum NetworkErrorType: ErrorType {
    case InvalidURL
}

class NetworkManager: NSObject {
    static func loadVenuesFromUrl(url: String, block: [Venue]? -> Void) throws {
        if let requestURL = NSURL(string: url) {
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                guard let httpResponse = response as? NSHTTPURLResponse,
                    data = data,
                    response = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String: AnyObject] where httpResponse.statusCode == 200 else {
                        block(nil)
                        return
                }
                print("Everyone is fine, file downloaded successfully.")
                let jsonArray = response["data"] as? [[String: AnyObject]]
                let venueArray = jsonArray?.flatMap { Venue.fromJSON($0) }
                block(venueArray)
            }
            task.resume()
        } else {
            throw NetworkErrorType.InvalidURL
        }
    }
}
