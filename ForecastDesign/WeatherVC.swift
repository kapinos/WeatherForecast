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
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var currentTypeWeatherLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: variables
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alpha = 0
        
        tableView.dataSource = self
        tableView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            cell.cofigureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    //MARK: inner methods
    func updateMainUI() {
        currentDateLabel.text = currentWeather.date
        currentTemperatureLabel.text = "\(currentWeather.currentTemperature) ºC"
        currentLocationLabel.text = currentWeather.cityName
        currentTypeWeatherLabel.text = currentWeather.weatherType
        currentImage.image = UIImage(named: currentWeather.weatherType)
        
        self.tableView.alpha = 1
        animateTable()
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete)  {
        let forecastURL = URL(string: FORECAST_TEN_DAYS_URL)
        Alamofire.request(forecastURL!).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any> {
                if let list = dict["list"] as? [Dictionary<String, Any>] {
                    for object in list {
                       // print(object) // get 10 days forecast
                        let forecast = Forecast(weatherDict: object)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.remove(at: 0) // remove the weather for today
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if locationManager.location != nil {
                currentLocation = locationManager.location
                
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                
                currentWeather.downloadWeatherDetails {
                    self.downloadForecastData {
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
            UIView.animate(withDuration: 2.5, delay: 0.5 * Double(index), usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion:{ finished in
                self.tableView.clipsToBounds = true
            })
            index += 1
        }
    }
}

