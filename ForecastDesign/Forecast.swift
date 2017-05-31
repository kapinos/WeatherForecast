//
//  Forecast.swift
//  Forecast
//
//  Created by Anastasia on 5/29/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    var _date:String!
    var _weatherType: String!
    var _highTemperature: Int!
    var _lowTemperature: Int!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
