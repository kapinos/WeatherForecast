//
//  Forecast.swift
//  Forecast for 10 days
//
//  Created by Anastasia on 5/29/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Alamofire

class ForecastPerDay {
    private var _dayOfWeek:String!
    private var _dayOfMonth:String!
    private var _month: String!
    private var _weatherType: String!
    private var _highTemperature: Int!
    private var _lowTemperature: Int!
    
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
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
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
    
    init(weatherDict: Dictionary<String, Any>) {
        
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
                self._weatherType = main
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            self._dayOfWeek = unixConvertedDate.dayOfTheWeek()
            self._dayOfMonth = unixConvertedDate.dayOfTheMonth()
            self._month = unixConvertedDate.month()
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
