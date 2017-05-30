//
//  CurrentWeather.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/30/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//


import Foundation
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemperature: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemperature: Double {
        if _currentTemperature == nil {
            _currentTemperature = 0.0
        }
        return _currentTemperature
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let dateL = Date()
        let currentDate = dateFormatter.string(from: dateL)
        
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    func downloadWeatherDetails(comleted: @escaping DownloadComplete) {
        // Alamofire
        let currentWeatherUrl = URL(string: CURRENT_WEATHER_URL)
        Alamofire.request(currentWeatherUrl!).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, Any>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, Any> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToCelsiusPreDevision = currentTemperature - 273.15
                        
                        let kelvinToCelsius = Double(round(10 * kelvinToCelsiusPreDevision/10))
                        self._currentTemperature = kelvinToCelsius
                    }
                }
            }
            //print("city: \(self._cityName!); weather: \(self._weatherType!); temperature: \(self._currentTemperature!)")
            comleted()
        }
    }
}

