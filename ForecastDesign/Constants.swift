//
//  Constants.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/30/17.
//  Copyright © 2017 Anastasia. All rights reserved.
// http://api.openweathermap.org/data/2.5/weather?lat=47.8261&lon=35.1904&appid=9b6febb338be90f2d99c78265226ec8f //current weather
// http://api.openweathermap.org/data/2.5/forecast/daily?lat=35&lon=139&cnt=10&appid=9b6febb338be90f2d99c78265226ec8f //forecast 10 days
// http://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=9b6febb338be90f2d99c78265226ec8f    //per 3 hours for 5 days

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "9b6febb338be90f2d99c78265226ec8f"

let UPDATE_APP_PERIOD_SECONDS = 2

typealias DownloadComplete = () -> ()

let LATITIDE_USER = LocationService.sharedInstance.latitude!
let LONGITUDE_USER = LocationService.sharedInstance.longitude!

let CURRENT_WEATHER_URL = "\(BASE_URL)weather?\(LATITUDE)\(LATITIDE_USER)\(LONGITUDE)\(LONGITUDE_USER)\(APP_ID)\(API_KEY)"
let FORECAST_TEN_DAYS_URL = "\(BASE_URL)forecast/daily?\(LATITUDE)\(LATITIDE_USER)\(LONGITUDE)\(LONGITUDE_USER)&cnt=10\(APP_ID)\(API_KEY)"
let FORECAST_EVERY_THREE_HOURS = "\(BASE_URL)forecast?\(LATITUDE)\(LATITIDE_USER)\(LONGITUDE)\(LONGITUDE_USER)\(APP_ID)\(API_KEY)"


enum CompassPoints: String {
    case North = "N"
    case NorthEast = "NE"
    case East = "E"
    case SouthEast = "SE"
    case South = "S"
    case SouthWest = "SW"
    case West = "W"
    case NorthWest = "NW"
    case Default = "D"
}

func getTheDirectionOfWindByDegrees(degree: Double) -> CompassPoints {
    
    var direction: CompassPoints
    
    switch degree {
    case 340...360,
         0...10:
        direction = .North
    case 10...70:
        direction = .NorthEast
    case 70...100:
        direction = .East
    case 100...160:
        direction = .SouthEast
    case 160...190:
        direction = .South
    case 190...250:
        direction = .SouthWest
    case 250...280:
        direction = .West
    case 280...340:
        direction = .NorthWest
    default:
        direction = .Default
    }
    return direction
}
