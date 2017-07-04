//
//  Forecast.swift
//  ForecastDesign
//
//  Created by Anastasia on 7/3/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Foundation

class Forecast {
    var _dayOfWeek: String!
    var _dayOfMonth: String!
    var _month: String!
    var _weatherType: String!
    var _weatherDescription: String!
    var _weatherIcon: String!
    
    var dayOfWeek: String {
        get {
            if _dayOfWeek == nil {
                _dayOfWeek = ""
            }
            return _dayOfWeek
        }
        set {
            _dayOfWeek = newValue
        }
    }
    
    var dayOfMonth: String {
        get {
            if _dayOfMonth == nil {
                _dayOfMonth = ""
            }
            return _dayOfMonth
        }
        set {
            _dayOfMonth = newValue
        }
    }
    
    var month: String {
        get {
            if _month == nil {
                _month = ""
            }
            return _month
        }
        set {
            _month = newValue
        }
    }
    
    var weatherType: String {
        get {
            if _weatherType == nil {
                _weatherType = ""
            }
            return _weatherType
        }
        set {
            _weatherType = newValue
        }
    }
    
    var weatherDescription: String {
        get {
            if _weatherDescription == nil {
                _weatherDescription = ""
            }
            return _weatherDescription
        }
        set {
            _weatherDescription = newValue
        }
    }
    
    var weatherIcon: String {
        get {
            if _weatherIcon == nil {
                _weatherIcon = ""
            }
            return _weatherIcon
        }
        set {
            _weatherIcon = newValue
        }
    }
    
    // get image for BG
    // contents weatherType + d/n
    func defineBGImage() -> String {
        var weatherBackgroundImage = _weatherType.lowercased()
        weatherBackgroundImage += _weatherIcon.contains("d") ? "d" : "n" // check day or night
        return weatherBackgroundImage
    }
    
    init(weatherDict: Dictionary<String, Any>) { }
    
    init() { }
}
