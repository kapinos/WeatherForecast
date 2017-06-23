//
//  WeatherVC.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/30/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var currentBGImage: UIImageView!
    @IBOutlet weak var currentTypeWeatherLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var swipeToCurrentDayDetails: UISwipeGestureRecognizer!
    
    //MARK: variables
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentWeather: CurrentWeather!
    var currentDay: ForecastPerDay!
    var forecasts = ForecastDaysInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alpha = 0
        
        tableView.dataSource = self
        tableView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        swipeToCurrentDayDetails.addTarget(self, action: #selector(self.currentDayDetails))
        
        currentWeather = CurrentWeather()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if forecasts.isEmpty() {
            locationAuthStatus()    // get the user's location
        } else {
            animateTable()
        }
    }
    
    //MARK: delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherByDayCell", for: indexPath) as? WeatherByDayCell {
            let forecast = forecasts.getForecast(byIndex: indexPath.row)
            cell.cofigureCell(forecast: forecast)
            return cell
        } else {
            return WeatherByDayCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = forecasts.getForecast(byIndex: indexPath.row)
        performSegue(withIdentifier: "SegueToDayDetails", sender: day)
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DayDetailsVC {
            if let selectedDay = sender as? ForecastPerDay {
                destination.forecastSelectedDay = selectedDay
            }
        }
    }
    
    func currentDayDetails() {
        performSegue(withIdentifier: "SegueToDayDetails", sender: currentDay)
    }

    //MARK: inner methods
    func updateMainUI() {
        currentDateLabel.text = currentWeather.date
        currentTemperatureLabel.text = "\(currentWeather.currentTemperature) ºC"
        currentLocationLabel.text = currentWeather.cityName
        currentTypeWeatherLabel.text = currentWeather.weatherType
        currentIcon.image = UIImage(named: currentWeather.weatherIcon)
        currentBGImage.image = UIImage(named: currentWeather.defineBGImage())
        
       // currentBGImage.image = UIImage(named: "thunderstormd") // check image
       // print("image: \(currentWeather.defineBGImage())") // checkValue image
        self.tableView.alpha = 1
        animateTable()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if locationManager.location != nil {
                currentLocation = locationManager.location
                
                LocationService.sharedInstance.latitude = currentLocation.coordinate.latitude
                LocationService.sharedInstance.longitude = currentLocation.coordinate.longitude
                
                currentWeather.downloadWeatherDetails {
                    self.forecasts.downloadForecastData {
                        self.currentDay = self.forecasts.remove(atIndex: 0)
                        self.updateMainUI()
                    }
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func animateTable() {
        tableView.reloadData()
        tableView.clipsToBounds = false
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 0.7, delay: 0.1 * Double(index), usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion:{ finished in
                self.tableView.clipsToBounds = true
            })
            index += 1
        }
    }
}

