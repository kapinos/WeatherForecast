//
//  ForecastHoursInfo.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Alamofire

class ForecastHoursInfo {
    
    private var _forecasts = [ForecastPerHour]()
    
    func count() -> Int {
        return _forecasts.count
    }
    
    func append(forecast: ForecastPerHour) {
        _forecasts.append(forecast)
    }
    
    func remove(atIndex: Int) {
        _forecasts.remove(at: atIndex)
    }
    
    func getForecast(byIndex: Int) -> ForecastPerHour {
        return _forecasts[byIndex]
    }
    
    func isEmpty() -> Bool {
        return (_forecasts.count == 0)
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete)  {
        let forecastURL = URL(string: FORECAST_EVERY_THREE_HOURS)
        Alamofire.request(forecastURL!).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any> {
                if let list = dict["list"] as? [Dictionary<String, Any>] {
                    for object in list {
                    //    print(object) // get 5 days every 3 hour forecast
                        let forecast = ForecastPerHour(weatherDict: object)
                        self._forecasts.append(forecast)
                    }
                  //  self._forecasts.remove(at: 0) // remove the weather for today
                }
            }
            completed()
        }
    }
}

