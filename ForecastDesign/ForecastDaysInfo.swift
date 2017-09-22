//
//  ForecastDaysInfo.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//
// contains array of ForecastPerDay - the geneal forecast for day

import Alamofire

class ForecastDaysInfo {

    private var _forecasts = [ForecastPerDay]()

    func count() -> Int {
        return _forecasts.count
    }
    
    func append(forecast: ForecastPerDay) {
        _forecasts.append(forecast)
    }
    
    func remove(atIndex: Int) -> ForecastPerDay {
       let element = _forecasts[atIndex]
        _forecasts.remove(at: atIndex)
        
        return element
    }
    
    func getForecast(byIndex: Int) -> ForecastPerDay {
        return _forecasts[byIndex]
    }
    
    func isEmpty() -> Bool {
        return (_forecasts.count == 0)
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete)  {
        let forecastURL = URL(string: FORECAST_TEN_DAYS_URL)
        Alamofire.request(forecastURL!).responseJSON { response in
            if response.error != nil {
                print("ERROR: \(String(describing: response.error?.localizedDescription))")
                return
            }
            
            let result = response.result
            
            self._forecasts.removeAll()
            
            var forecastsTmp = [ForecastPerDay]()
            if let dict = result.value as? Dictionary<String, Any> {
                if let list = dict["list"] as? [Dictionary<String, Any>] {
                    for object in list {
                        // print(object) // get 10 days forecast
                        let forecast = ForecastPerDay(weatherDict: object)
                        forecastsTmp.append(forecast)
                    }
                    self._forecasts.append(contentsOf: forecastsTmp[0...5]) // forecast for 5 days 
                }
            }
            completed()
        }
    }
}
