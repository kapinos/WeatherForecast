//
//  ForecastHoursInfo.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Alamofire

class ForecastHoursInfo: Sequence, IteratorProtocol {
    
    private var _forecasts = [ForecastPerHour]()
    private var index: Int = 0
    var count: Int {
        get {
            return _forecasts.count
        }
    }
    
    func next() -> ForecastPerHour? {
        if count == 0 {
            return nil
        } else {
            if index < count {
                let forecast = _forecasts[index]
                index += 1
                return forecast
            }
            index = 0
            return nil
        }
    }

    subscript(index: Int) -> ForecastPerHour {
        get {
            return _forecasts[index]
        }
        set(newValue) {
            _forecasts[index] = newValue
        }
    }
    
    func append(forecast: ForecastPerHour) {
        _forecasts.append(forecast)
    }
    
    func remove(atIndex: Int) {
        _forecasts.remove(at: atIndex)
    }
    
    func getForecastForMiddleOfTheDay() -> ForecastPerHour {
        let indexMiddle = Int(round(Double(_forecasts.count/2)))
        return _forecasts[indexMiddle]
    }
    
    func isEmpty() -> Bool {
        return (_forecasts.count == 0)
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete)  {
        let forecastURL = URL(string: FORECAST_EVERY_THREE_HOURS)
        Alamofire.request(forecastURL!).responseJSON { response in
            if response.error != nil {
                print("ERROR: \(String(describing: response.error?.localizedDescription))")
                return
            }
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any> {
                if let list = dict["list"] as? [Dictionary<String, Any>] {
                    self._forecasts.removeAll()
                    for object in list {
                    //    print(object) // get 5 days every 3 hour forecast
                        let forecast = ForecastPerHour(weatherDict: object)
                        self._forecasts.append(forecast)
                    }
                }
            }
            completed()
        }
    }
}

