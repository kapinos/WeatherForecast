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

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "" // left only arrow
        
        tableView.delegate = self
        tableView.dataSource = self
                
        let selectedDay = _forecastHours.getForecastForMiddleOfTheDay()
        
        currentBGImage.image = UIImage(named: selectedDay.defineBGImage())
        dayWeekLabel.text = selectedDay.dayOfWeek
        dayMonthLabel.text = selectedDay.dayOfMonth
        monthLabel.text = selectedDay.month
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _forecastHours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherByHourCell", for: indexPath) as? WeatherByHourCell {
            let forecast = _forecastHours[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherByHourCell()
        }
    }
    
    func updateForecast(forecast: ForecastHoursInfo) {
        print("I've got the data")
        _forecastHours = forecast
        
        tableView.reloadData()
    }
}
