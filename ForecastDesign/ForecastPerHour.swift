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
    private var _time:String!
    private var _weatherType: String!
    private var _temperature: Int!
    
    // not yet
//    private var _dayWeek: String!
//    private var _dayMonth: String!
//    private var _month: String
    private var _rain: Int!
    private var _windSpeed: Double!
    private var _windDegree: Double!
    private var _humidity: Int!
    
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
    
    var temperature: Int {
        if _temperature == nil {
            _temperature = 0
        }
        return _temperature
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
        }
        
        if let wind = weatherDict["wind"] as? Dictionary<String, Any> {
            if let speed = wind["speed"] as? Double {
                self._windSpeed = Double(round(10 * speed/10))
            }
            if let degree = wind["deg"] as? Double {
                self._windDegree = Double(round(10 * degree/10))
            }
        }
        
        if let time = weatherDict["dt_txt"] as? String {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            formatter.timeStyle = .short
            self._time = time
        }
        
        //!!!!!!! dayWeek, dayMonth, time, rain
        
//        if let rain = weatherDict["rain"] as? Dictionary<String, Any> {
//            if let rainPersentage = rain[""]
//        }
        
//        if let date = weatherDict["dt"] as? Double {
//            
//            let unixConvertedDate = Date(timeIntervalSince1970: date)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .full
//            dateFormatter.dateFormat = "EEEE"
//            dateFormatter.timeStyle = .none
//            self._date = unixConvertedDate.dayOfTheWeek()
//        }
    }
}

//extension Date {
//    func dayOfTheWeek() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: self)
//    }
//}

