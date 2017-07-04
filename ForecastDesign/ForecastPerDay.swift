//
//  ForecastPerDay.swift
//  Forecast for one day
//
//  Created by Anastasia on 5/29/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Alamofire

class ForecastPerDay: Forecast {
    private var _highTemperature: Int!
    private var _lowTemperature: Int!
    
    var highTemperature: Int {
        if _highTemperature == nil {
            _highTemperature = 0
        }
        return _highTemperature
    }
    
    var lowTemperature: Int {
        if _lowTemperature == nil {
            _lowTemperature = 0
        }
        return _lowTemperature
    }
    
    override init(weatherDict: Dictionary<String, Any>) {
        super.init(weatherDict: weatherDict)
    
        if let temp = weatherDict["temp"] as? Dictionary<String, Any> {
            if let min = temp["min"] as? Double {
                let kelvinToCelsiumPreDivision = min - 273.15
                let kelvinToCelsium = Int(round(10 * kelvinToCelsiumPreDivision/10))
                self._lowTemperature = kelvinToCelsium
            }
            
            if let max = temp["max"] as? Double {
                let kelvinToCelsiumPreDivision = max - 273.15
                let kelvinToCelsium = Int(round(10 * kelvinToCelsiumPreDivision/10))
                self._highTemperature = kelvinToCelsium
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
        
        if let date = weatherDict["dt"] as? Double {            
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            dayOfWeek = unixConvertedDate.dayOfTheWeek()
            dayOfMonth = unixConvertedDate.dayOfTheMonth()
            month = unixConvertedDate.month()
        }
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"       // Wednesday
        return dateFormatter.string(from: self)
    }
    
    func dayOfTheMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"          // 7
        return dateFormatter.string(from: self)
    }
    
    func month() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"       // June
        return dateFormatter.string(from: self)
    }
    
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"      // 15:00
        return dateFormatter.string(from: self)
    }
}
