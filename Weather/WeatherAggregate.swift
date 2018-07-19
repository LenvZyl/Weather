//
//  WeatherAggregate.swift
//  Weather
//
//  Created by Len X van Zyl on 7/19/18.
//  Copyright © 2018 Len X van Zyl. All rights reserved.
//

import Foundation
class WeatherAggregate {
    
    static let sharedInstance: WeatherAggregate = WeatherAggregate()
    
    var weatherSelected: Weather?
}
