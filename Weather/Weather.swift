//
//  Weather.swift
//  Weather
//
//  Created by Len X van Zyl on 7/18/18.
//  Copyright © 2018 Len X van Zyl. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary:String
    let icon:String
    let temperature:Double
    let windSpeed: Double
    let humidity: Double
    let precipProbability: Double
    let visibility: Double
    
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let windSpeed = json["windSpeed"] as? Double else {throw SerializationError.missing("windSpeed is missing")}
        guard let humidity = json["humidity"] as? Double else {throw SerializationError.missing("humidity is missing")}
        guard let precipProbability = json["precipProbability"] as? Double else {throw SerializationError.missing("precipProbability is missing")}
        guard let visibility = json["visibility"] as? Double else {throw SerializationError.missing("visibility is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.precipProbability = precipProbability
        self.visibility = visibility
        
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/\(API.apiKey)/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
            }
        }
        task.resume()
    }
}

