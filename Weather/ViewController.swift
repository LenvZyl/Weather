//
//  ViewController.swift
//  Weather
//
//  Created by Len X van Zyl on 7/18/18.
//  Copyright © 2018 Len X van Zyl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    
    var weatherAggregate: WeatherAggregate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAggregate = WeatherAggregate.sharedInstance
        displayWeather()
    }
    
    func displayWeather() {
        if let weatherSelected = weatherAggregate.weatherSelected {
            currentTemperatureLabel.text = "\(Int(weatherSelected.temperature)) ºF"
            currentHumidityLabel.text = "\(Int((weatherSelected.humidity))) %"
            currentPrecipitationLabel.text = "\(Int((weatherSelected.precipProbability))) %"
            currentWeatherIcon.image = UIImage(named: (weatherSelected.icon))
            currentSummaryLabel.text = "\(String(describing: weatherSelected.summary))"
        }
        
    }
}

