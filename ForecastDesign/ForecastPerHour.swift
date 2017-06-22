//
//  ForecastPerHour.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Alamofire

class ForecastPerHour {

    private var _dayOfWeek: String!
    private var _dayOfMonth: String!
    private var _month: String!
    private var _time:String!
    private var _weatherType: String!
    private var _weatherDescription: String!
    private var _weatherIcon: String!
    private var _temperature: Int!
    private var _rain: Int!
    private var _windSpeed: Double!
    private var _windDirection: String!
    private var _humidity: Int!
    
    var dayOfWeek: String {
        if _dayOfWeek == nil {
            _dayOfWeek = ""
        }
        return _dayOfWeek
    }
    
    var dayOfMonth: String {
        if _dayOfMonth == nil {
            _dayOfMonth = ""
        }
        return _dayOfMonth
    }
    
    var month: String {
        if _month == nil {
            _month = ""
        }
        return _month
    }
    
    var time: String {
        if _time == nil {
            _time = ""
        }
        return _time
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var weatherDescription: String {
        if _weatherDescription == nil {
            _weatherDescription = ""
        }
        return _weatherDescription
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    var temperature: Int {
        if _temperature == nil {
            _temperature = 0
        }
        return _temperature
    }
    
    var rain: Int {
        if _rain == nil {
            _rain = 0
        }
        return _rain
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
    
    init(weatherDict: Dictionary<String, Any>) {
        
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
                self._weatherType = main
            }
            
            if let description = weather[0]["description"] as? String {
                self._weatherDescription = description
            }
            
            if let icon = weather[0]["icon"] as? String {
                self._weatherIcon = icon
            }
        }
        
        if let rain = weatherDict["rain"] as? Double {
            self._rain = Int(round(100 * rain))
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
            
            self._dayOfWeek = unixConvertedDate.dayOfTheWeek()
            self._dayOfMonth = unixConvertedDate.dayOfTheMonth()
            self._month = unixConvertedDate.month()
            self._time = unixConvertedDate.time()
        }
        // check for every forecast        
//        print("date & time: \(self.dayOfWeek), \(self.dayOfMonth) \(self.month) \(self.time), weather: \(self.weatherType), temp: \(self.temperature), rain: \(self.rain), wind direction: \(self.windDirection)  speedWind: \(self.windSpeed)")
    }
}



