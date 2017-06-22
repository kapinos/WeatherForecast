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
    @IBOutlet var swipeToOverallForecast: UISwipeGestureRecognizer!
    
    // MARK: variables
    private var _forecastSelectedDay: ForecastPerDay!
    private var _forecastHours = ForecastHoursInfo()

    var forecastSelectedDay: ForecastPerDay {
        get {
            return _forecastSelectedDay
        } set {
            _forecastSelectedDay = newValue
        }
    }
    
    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.alpha = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        swipeToOverallForecast.addTarget(self, action: #selector(self.returnToOverallForecast))
        
        currentBGImage.image = UIImage(named: _forecastSelectedDay.defineBGImage())
        dayWeekLabel.text = _forecastSelectedDay.dayOfWeek
        dayMonthLabel.text = _forecastSelectedDay.dayOfMonth
        monthLabel.text = _forecastSelectedDay.month
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if _forecastHours.isEmpty() {
            _forecastHours.downloadForecastData(dayMonth: _forecastSelectedDay.dayOfMonth) {
                self.tableView.alpha = 1
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _forecastHours.count()
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
    
    // MARK: inner methods
    func returnToOverallForecast() {
        self.performSegue(withIdentifier: "segueToOverallForecast", sender: nil)
    }
}
