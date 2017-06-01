//
//  DayDetailsVC.swift
//  ForecastDesign
//
//  Created by Anastasia on 5/31/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class DayDetailsVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var dayWeekLabel: UILabel!
    @IBOutlet weak var dayMonthLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: variables
    private var _forecastSelectedDay: ForecastPerDay!

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
        
        dayWeekLabel.text = _forecastSelectedDay.dayOfWeek
        dayMonthLabel.text = _forecastSelectedDay.dayOfMonth
        monthLabel.text = _forecastSelectedDay.month
    }


}
