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
    var forecastsDays = ForecastDaysInfo()
    var forecastDaysForTableView = ForecastDaysInfo()
    var forecastsHours = ForecastHoursInfo()
    var timeBeingInBackground: Date!
    var detailsVC: DayDetailsVC?
    var downloadAgain = false
    
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
        
        if forecastsDays.isEmpty() {
            downloadForecastByUserLocation(){}    // get the user's location
            
        } else {
            animateTable()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appRestoredFromBackground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        //NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDaysForTableView.count() // show table without current day
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherByDayCell", for: indexPath) as? WeatherByDayCell {
            let forecast = forecastDaysForTableView.getForecast(byIndex: indexPath.row)
            cell.cofigureCell(forecast: forecast)
            return cell
        } else {
            return WeatherByDayCell()
        }
    }

    var dayMonthSelected = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = forecastsDays.getForecast(byIndex: indexPath.row)
        
        dayMonthSelected = day.dayOfMonth
        let hoursForSelectedDay = getForecastByHoursFor(dayMonth: dayMonthSelected)
        if !hoursForSelectedDay.isEmpty() {
            performSegue(withIdentifier: "SegueToDayDetails", sender: hoursForSelectedDay)
        }
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dayDetailsVC = segue.destination as? DayDetailsVC {
            self.detailsVC = dayDetailsVC
            if let arrayForecastsByHours = sender as? ForecastHoursInfo {
                dayDetailsVC.forecastHours = arrayForecastsByHours
            }
        }
    }
    
    func currentDayDetails() {
        let hoursForSelectedDay = getForecastByHoursFor(dayMonth: currentWeather.dayOfMonth)
        if !hoursForSelectedDay.isEmpty() {
            performSegue(withIdentifier: "SegueToDayDetails", sender: hoursForSelectedDay)
        }
    }

    //MARK: inner methods
    func updateMainUI() {
        currentDateLabel.text = currentWeather.date
        currentTemperatureLabel.text = "\(currentWeather.currentTemperature) ºC"
        currentLocationLabel.text = currentWeather.cityName
        currentTypeWeatherLabel.text = currentWeather.weatherType
        currentIcon.image = UIImage(named: currentWeather.weatherIcon)
        currentBGImage.image = UIImage(named: currentWeather.defineBGImage())
        
        self.tableView.alpha = 1
        animateTable()
        
        // currentBGImage.image = UIImage(named: "thunderstormd") // check image
        // print("image: \(currentWeather.defineBGImage())") // checkValue image
    }
    
    func downloadForecastByUserLocation(completed: @escaping () -> ()) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if locationManager.location != nil {
                currentLocation = locationManager.location
                
                LocationService.sharedInstance.latitude = currentLocation.coordinate.latitude
                LocationService.sharedInstance.longitude = currentLocation.coordinate.longitude
                
                //**
                print("lat = \(LocationService.sharedInstance.latitude); lon = \(LocationService.sharedInstance.longitude)")
                //**
                
                
                currentWeather.downloadWeatherDetails {
                    self.forecastsDays.downloadForecastData {
                        self.forecastsHours.downloadForecastData {
                           self.forecastDaysForTableView = self.forecastsDays
                            _ = self.forecastDaysForTableView.remove(atIndex: 0)
                            self.updateMainUI()
                            completed()
                        }
                    }
                }
            }
        } else {
            downloadAgain = true
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !downloadAgain {
            return
        }
        if status == .authorizedAlways  ||
            status == .authorizedWhenInUse {
            downloadForecastByUserLocation(){}
        }
    }
    
    func getForecastByHoursFor(dayMonth: String) -> ForecastHoursInfo {
        
        let arrayForecastsHours = ForecastHoursInfo()
        for i in 0..<forecastsHours.getCount() {
            let forecast = forecastsHours.getForecast(byIndex: i)
            if forecast.dayOfMonth == dayMonth {
                arrayForecastsHours.append(forecast: forecast)
            }
        }
        return arrayForecastsHours
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
    
    // MARK: lifecycle APP
    
    func appMovedToBackground() {
        // **only for test-------
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        print("appWillResignActive WeatherVC: \(currentDate)")
        
        if detailsVC != nil {
            if let hours = detailsVC?.forecastHours {
                for i in 0..<hours.getCount() {
                    let tmp = hours.getForecast(byIndex: i).temperature
                    hours.getForecast(byIndex: i).temperature = -tmp
                    print("\(hours.getForecast(byIndex: i).temperature)")
                }
            }
        }
        // **only for test---------
        
        timeBeingInBackground = date
    }
    
    func appRestoredFromBackground() {
        // **only for test---------
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        print("appWillEnterForeground WeatherVC: \(currentDate)")
        // **only for test---------
        
        let period = date.timeIntervalSince(timeBeingInBackground)
        print("period: \(period)")       
        
        // update every 10 minutes
        if Int(period) > UPDATE_APP_PERIOD_SECONDS {
            print("update the data WeatherVC")
            
            downloadForecastByUserLocation {
                if self.dayMonthSelected != "" {
                    let hoursForSelectedDay = self.getForecastByHoursFor(dayMonth: self.dayMonthSelected)
                    self.detailsVC?.updateForecast(forecast: hoursForSelectedDay)
                }
            }
        }
    }
}

