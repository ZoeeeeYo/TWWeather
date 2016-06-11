//
//  Venue.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

enum WeatherCondition: String {
    case Clear = "Clear"
    case Thunderstorm = "Thunderstorm"
    case Mist = "Mist"
    case Fog = "Fog"
    case ShallowFog = "Shallow Fog"
    case PatchesOfFog = "Patches of Fog"
    case PartlyCloudy = "Partly Cloudy"
    case Smoke = "Smoke"
    case Overcast = "Overcast"
    case LightRain = "Light Rain"
    case LightRainShowers = "Light Rain Showers"
    case ScatteredClouds = "Scattered Clouds"
    case Snow = "Snow"
    case Rain = "Rain"
    case Haze = "Haze"
    case MostlyCloudy = "Mostly Cloudy"
}

class Venue: NSObject {
    
    static let KeyVenueId = "_venueID"
    static let KeyVenueName = "_name"
    static let KeyCountry = "_country"
    static let KeyWeatherCondition = "_weatherCondition"
    static let KeyWind = "_weatherWind"
    static let KeyHumidity = "_weatherHumidity"
    static let KeyTemperature = "_weatherTemp"
    static let KeyFeelLike = "_weatherFeelsLike"
    static let KeySport = "_sport"
    static let KeyLastUpdated = "_weatherLastUpdated"
    
    private(set) var venueId: String
    private(set) var venueName: String
    private(set) var country: Country
    private(set) var sport: Sport?
    private(set) var weatherCondition: WeatherCondition?
    private(set) var wind: String?
    private(set) var humidity: Double?
    private(set) var temperature: Double?
    private(set) var feelLike: Double?
    private(set) var lastUpdated: NSDate?
    
    init(venueId: String,
        venueName: String,
        country: Country,
        sport: Sport?,
        weatherCondition: WeatherCondition?,
        wind: String?,
        humidity: Double?,
        temperature: Double?,
        feelLike: Double?,
        lastUpdated: NSDate?) {
            
        self.venueId = venueId
        self.venueName = venueName
        self.country = country
        self.sport = sport
        self.weatherCondition = weatherCondition
        self.wind = wind
        self.humidity = humidity
        self.temperature = temperature
        self.feelLike = feelLike
        self.lastUpdated = lastUpdated
    }
    
    static func fromJSON(json: [String: AnyObject]) -> Venue? {
        guard let venueId = json[KeyVenueId] as? String,
            venueName = json[KeyVenueName] as? String,
            countryJson = json[KeyCountry] as? [String: AnyObject],
            country = Country.fromJSON(countryJson)
        else { return nil }
        
        let sport: Sport?
        if let sportJson = json[KeySport] as? [String: AnyObject] {
            sport = Sport.fromJSON(sportJson)
        } else {
            sport = nil
        }
        
        let weatherCondition: WeatherCondition?
        if let weatherConditionString = json[KeyWeatherCondition] as? String {
            weatherCondition = WeatherCondition.init(rawValue: weatherConditionString)
        } else {
            weatherCondition = nil
        }
        
        let wind = json[KeyWind] as? String
        let humidity = json[KeyHumidity] as? Double
        let temperature = json[KeyTemperature] as? Double
        let feelLike = json[KeyFeelLike] as? Double
        
        let lastUpdated: NSDate?
        if let timeStamp = json[KeyLastUpdated] as? Double {
            lastUpdated = dateFromInterval(timeStamp)
        } else {
            lastUpdated = nil
        }
        
        return Venue(venueId: venueId, venueName: venueName, country: country, sport: sport, weatherCondition: weatherCondition, wind: wind, humidity: humidity, temperature: temperature, feelLike: feelLike, lastUpdated: lastUpdated)
    }
    
    static func dateFromInterval(timeStamp: Double) -> NSDate {
        return NSDate(timeIntervalSince1970: timeStamp)
    }
}


