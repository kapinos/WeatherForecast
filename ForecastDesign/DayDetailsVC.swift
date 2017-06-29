//
//  DayDetailsVC.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class DayDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: IBOutlets
    @IBOutlet weak var dayWeekLabel: UILabel!
    @IBOutlet weak var dayMonthLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentBGImage: UIImageView!
    
    // MARK: variables
    private var _forecastHours = ForecastHoursInfo()
    var timeBeingInBackground: Date!
    var selectedDayOfMonth = ""
    
    var forecastHours: ForecastHoursInfo {
        get {
            return _forecastHours
        } set {
            _forecastHours = newValue
        }
    }
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.clear

        tableView.delegate = self
        tableView.dataSource = self
                
        let selectedDay = _forecastHours.getForecastForMiddleOfTheDay()
        selectedDayOfMonth = selectedDay.dayOfMonth
        
        currentBGImage.image = UIImage(named: selectedDay.defineBGImage())
        dayWeekLabel.text = selectedDay.dayOfWeek
        dayMonthLabel.text = selectedDay.dayOfMonth
        monthLabel.text = selectedDay.month
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appRestoredFromBackground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _forecastHours.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherByHourCell", for: indexPath) as? WeatherByHourCell {
            let forecast = _forecastHours.getForecast(byIndex: indexPath.row)
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherByHourCell()
        }
    }
    
    // MARK: lifecycle APP
    
    func appMovedToBackground() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        print("appWillResignActive DetailsVC: \(currentDate)")
        
        timeBeingInBackground = date
    }
    
    func appRestoredFromBackground() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        print("appWillEnterForeground DetailsVC: \(currentDate)")
        
        let period = date.timeIntervalSince(timeBeingInBackground)
        print("period: \(period)")
        
        // update every 10 minutes
        if Int(period) > UPDATE_APP_PERIOD_SECONDS {
            print("update the data")
            
            _forecastHours = getForecastByHoursFor(dayMonth: selectedDayOfMonth)
            tableView.reloadData()
        }
    }
    
    
    func getForecastByHoursFor(dayMonth: String) -> ForecastHoursInfo {
        
        let arrayForecastsHours = ForecastHoursInfo()
        var forecastsHours = ForecastHoursInfo()
        
        forecastsHours.downloadForecastData{}
            
            for i in 0..<forecastsHours.getCount() {
                let forecast = forecastsHours.getForecast(byIndex: i)
                if forecast.dayOfMonth == dayMonth {
                    arrayForecastsHours.append(forecast: forecast)
                }
            }
       
        return arrayForecastsHours
    }
}
