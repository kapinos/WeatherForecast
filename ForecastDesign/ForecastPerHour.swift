//
//  ForecastPerHour.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Alamofire

class ForecastPerHour: Forecast {

    private var _time:String!
    private var _temperature: Int!
    private var _rainVolume: String!
    private var _windSpeed: Double!
    private var _windDirection: String!
    private var _humidity: Int!
    
    var time: String {
        if _time == nil {
            _time = ""
        }
        return _time
    }
    
//    var temperature: Int {
//        get {
//            if _temperature == nil {
//                _temperature = 0
//            }
//            return _temperature
//        }
//        set {
//            _temperature = newValue
//        }
//    }
    
    var temperature: Int {
        if _temperature == nil {
            _temperature = 0
        }
        return _temperature
    }
    
    var rainVolume: String {
        if _rainVolume == nil {
            _rainVolume = ""
        }
        return _rainVolume
    }
    
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    
    var windDirection: String {
        if _windDirection == nil {
            _windDirection = ""
        }
        return _windDirection
    }
    
    var humidity: Int {
        if _humidity == nil {
            _humidity = 0
        }
        return _humidity
    }
    
  override init(weatherDict: Dictionary<String, Any>) {
        super.init(weatherDict: weatherDict)
        
        if let main = weatherDict["main"] as? Dictionary<String, Any> {
            if let temp = main["temp"] as? Double {
                let kelvinToCelsiumPreDivision = temp - 273.15
                let kelvinToCelsium = Int(round(10 * kelvinToCelsiumPreDivision/10))
                self._temperature = kelvinToCelsium
            }
            
            if let humidity = main["humidity"] as? Int {
                self._humidity = humidity
            }
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, Any>] {
            if let main = weather[0]["main"] as? String {
                weatherType = main
            }
            
            if let description = weather[0]["description"] as? String {
                weatherDescription = description
            }
            
            if let icon = weather[0]["icon"] as? String {
                weatherIcon = icon
            }
        }
        
        if let rain = weatherDict["rain"] as? Dictionary<String, Any> {
            if let precipitations = rain["3h"] as? Double {
                let volume = getTheRainIntensityByVolume(volume: Double(round(precipitations * 100))/100)
                self._rainVolume = volume.rawValue
            } else {
                self._rainVolume = RainIntensity.Default.rawValue
            }
        }
        
        if let wind = weatherDict["wind"] as? Dictionary<String, Any> {
            if let speed = wind["speed"] as? Double {
                self._windSpeed = Double(round(10 * speed)/10)
            }
            if let degree = wind["deg"] as? Double {
                let direction = getTheDirectionOfWindByDegrees(degree: Double(round(degree)))
                self._windDirection = direction.rawValue
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            
            dayOfWeek = unixConvertedDate.dayOfTheWeek()
            dayOfMonth = unixConvertedDate.dayOfTheMonth()
            month = unixConvertedDate.month()
            self._time = unixConvertedDate.time()
        }
        // check for every forecast        
//        print("date & time: \(self.dayOfWeek), \(self.dayOfMonth) \(self.month) \(self.time), weather: \(self.weatherType), temp: \(self.temperature), rain: \(self.rain), wind direction: \(self.windDirection)  speedWind: \(self.windSpeed)")
    }
}



