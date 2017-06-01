//
//  Location.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/30/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import CoreLocation

class LocationService {
    static var sharedInstance = LocationService()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
