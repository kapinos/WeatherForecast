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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appRestoredFromBackground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastsDays.count() - 1 // get forecastsDays count without current day
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherByDayCell", for: indexPath) as? WeatherByDayCell {
            let forecast = forecastsDays.getForecast(byIndex: indexPath.row+1)
            cell.cofigureCell(forecast: forecast)
            return cell
        } else {
            return WeatherByDayCell()
        }
    }

    var dayMonthSelected = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = forecastsDays.getForecast(byIndex: indexPath.row+1)
        
        dayMonthSelected = day.dayOfMonth
        let hoursForSelectedDay = getForecastByHoursFor(dayMonth: dayMonthSelected)
        if !hoursForSelectedDay.isEmpty() {
            performSegue(withIdentifier: "SegueToDayDetails", sender: hoursForSelectedDay)
        }
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //print("downloadAgain: \(downloadAgain); status: \(status.rawValue)")
        if !downloadAgain {
            return
        }
        if status == .authorizedAlways  ||
            status == .authorizedWhenInUse {
            downloadForecastByUserLocation(){}
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        downloadForecastByUserLocation() {}
        //print("didUpdateLocation; newLocation: \(manager.location)")
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
        //print("Status: \(CLLocationManager.authorizationStatus().rawValue)")
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            downloadAgain = true
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        downloadAgain = false
        //print("location: \(locationManager.location)")
        if locationManager.location == nil {
            locationManager.startUpdatingLocation()
            return
        }
        
        currentLocation = locationManager.location
        
        LocationService.sharedInstance.latitude = currentLocation.coordinate.latitude
        LocationService.sharedInstance.longitude = currentLocation.coordinate.longitude
        
        currentWeather.downloadWeatherDetails {
            self.forecastsDays.downloadForecastData {
                self.forecastsHours.downloadForecastData {
                    self.updateMainUI()
                    completed()
                }
            }
        }
    }
    
    func getForecastByHoursFor(dayMonth: String) -> ForecastHoursInfo {
        
        let arrayForecastsHours = ForecastHoursInfo()
        for forecast in forecastsHours {
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
        let date = Date()
        timeBeingInBackground = date
    }
    
    func appRestoredFromBackground() {
        let date = Date()
        let period = date.timeIntervalSince(timeBeingInBackground)
        print("period: \(period)")       
        
        // update every 10 minutes
        if Int(period) >= UPDATE_APP_PERIOD_SECONDS {
            print("update the data WeatherVC")
            
            self.downloadForecastByUserLocation {
                if self.dayMonthSelected != "" {
                    let hoursForSelectedDay = self.getForecastByHoursFor(dayMonth: self.dayMonthSelected)
                    self.detailsVC?.updateForecast(forecast: hoursForSelectedDay)
                }
            }
        }
    }
}

