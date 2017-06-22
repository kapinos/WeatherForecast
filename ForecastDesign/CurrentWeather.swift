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
    private var _cityName: String!
    private var _date: String! //
    private var _weatherType: String! //
    private var _weatherDescription: String!//
    private var _weatherIcon: String!
    private var _currentTemperature: Int!//
    
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
    
    var currentTemperature: Int {
        if _currentTemperature == nil {
            _currentTemperature = 0
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
        
        self._date = "\(currentDate)"
        
        return _date
    }
    
    // get image for BG
    // contents weatherType + d/n
    func defineBGImage() -> String {
        var weatherBackgroundImage = _weatherType.lowercased()
        weatherBackgroundImage += _weatherIcon.contains("d") ? "d" : "n" // check day or night
        
        return weatherBackgroundImage
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
                    
                    if let description = weather[0]["description"] as? String {
                        self._weatherDescription = description
                    }
                    
                    if let icon = weather[0]["icon"] as? String {
                        self._weatherIcon = icon
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, Any> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToCelsiusPreDevision = currentTemperature - 273.15
                        
                        let kelvinToCelsius = Int(round(10 * kelvinToCelsiusPreDevision/10))
                        self._currentTemperature = kelvinToCelsius
                    }
                }
            }
            //print("city: \(self._cityName!); weather: \(self._weatherType!); temperature: \(self._currentTemperature!)")
            comleted()
        }
    }
}

