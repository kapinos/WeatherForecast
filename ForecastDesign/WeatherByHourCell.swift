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
    @IBOutlet weak var windDegreeImage: UIImageView! 
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    func configureCell(forecast: ForecastPerHour) {
        timeLabel.text = "\(forecast.time)"
        weatherTypeImage.image = UIImage(named: forecast.weatherIcon)
        weatherTypeLabel.text = "\(forecast.weatherDescription)"
        temperatureLabel.text = "\(forecast.temperature) °C"
        rainPercentageLabel.text = "\(forecast.precipitationsPercent) %"
        windDegreeImage.image = UIImage(named: forecast.windDirection)
        windSpeedLabel.text = "\(forecast.windSpeed) h/s"
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
}
