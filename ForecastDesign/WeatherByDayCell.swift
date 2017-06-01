//
//  WeatherByDayCell.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/30/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class WeatherByDayCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var typeWeatherLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    
    func cofigureCell(forecast: ForecastPerDay) {
        lowTemperatureLabel.text = "\(forecast.lowTemperature) °C"
        highTemperatureLabel.text = "\(forecast.highTemperature) °C"
        typeWeatherLabel.text = "\(forecast.weatherType)"
        weatherIcon.image = UIImage(named: forecast.weatherType)
        dayOfWeekLabel.text = forecast.dayOfWeek
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        //self.layer.cornerRadius = 15
    }
}
