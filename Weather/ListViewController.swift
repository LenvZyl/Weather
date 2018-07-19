//
//  ListViewController.swift
//  Weather
//
//  Created by Len X van Zyl on 7/18/18.
//  Copyright © 2018 Len X van Zyl. All rights reserved.
//

import UIKit
import CoreLocation
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var navbar: UINavigationItem!
    @IBOutlet var listTableView: UITableView!
    
    var weatherAggregate: WeatherAggregate!
    var weatherForcastData = [Weather]()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAggregate = WeatherAggregate.sharedInstance
        listTableView.delegate = self
        listTableView.dataSource = self
//        getLocation()
        getCurrentLocation()
        
    }
    
//    func getLocation(){
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//
//        locationManager.stopUpdatingLocation()
//        let coordinations = CLLocationCoordinate2D(latitude: -33.653890,longitude: 19.461607)
//        Weather.forecast(withLocation: coordinations, completion: { (results: [Weather]?)
//            in
//            if let weatherData = results {
//                self.weatherForcastData = weatherData
//                DispatchQueue.main.async {
//                    self.listTableView.reloadData()
//                }
//            }
//        })
//    }
    
    func getCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.last!
        manager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        Weather.forecast(withLocation: coordinations, completion: { (results: [Weather]?)
            in
            if let weatherData = results {
                self.weatherForcastData = weatherData
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
        })
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date!)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherForcastData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        let weatherObject = weatherForcastData[indexPath.section]
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) ºF"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(weatherForcastData[indexPath.section])
        weatherAggregate.weatherSelected = weatherForcastData[indexPath.section]
        self.performSegue(withIdentifier: "ShowWeatherDetails", sender: self)
    }

}
