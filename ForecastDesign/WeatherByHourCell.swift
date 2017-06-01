//
//  WeatherByHourCell.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class WeatherByHourCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherTypeImage: UIImageView!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainPercentageLabel: UILabel!
    @IBOutlet weak var windDegreeImage: UIImageView!    // haven't
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    func cofigureCell(forecast: ForecastPerDay) {
//        lowTemperatureLabel.text = "\(forecast.lowTemperature) °C"
//        highTemperatureLabel.text = "\(forecast.highTemperature) °C"
//        typeWeatherLabel.text = "\(forecast.weatherType)"
//        weatherIcon.image = UIImage(named: forecast.weatherType)
//        dayOfWeekLabel.text = forecast.date
//        
//        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }

}
