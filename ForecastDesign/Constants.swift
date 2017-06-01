//
//  Constants.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/30/17.
//  Copyright © 2017 Anastasia. All rights reserved.
// http://api.openweathermap.org/data/2.5/weather?lat=47.8261&lon=35.1904&appid=9b6febb338be90f2d99c78265226ec8f // current weather
// forecast 10 days
// http://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=9b6febb338be90f2d99c78265226ec8f    // per 3 hours for 5 days

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "9b6febb338be90f2d99c78265226ec8f"

typealias DownloadComplete = () -> ()

let LATITIDE_USER = LocationService.sharedInstance.latitude!
let LONGITUDE_USER = LocationService.sharedInstance.longitude!

let CURRENT_WEATHER_URL = "\(BASE_URL)weather?\(LATITUDE)\(LATITIDE_USER)\(LONGITUDE)\(LONGITUDE_USER)\(APP_ID)\(API_KEY)"
let FORECAST_TEN_DAYS_URL = "\(BASE_URL)forecast/daily?\(LATITUDE)\(LATITIDE_USER)\(LONGITUDE)\(LONGITUDE_USER)&cnt=10\(APP_ID)\(API_KEY)"
let FORECAST_EVERY_THREE_HOURS = "\(BASE_URL)forecast?\(LATITUDE)\(LATITIDE_USER)\(LONGITUDE)\(LONGITUDE_USER)\(APP_ID)\(API_KEY)"
