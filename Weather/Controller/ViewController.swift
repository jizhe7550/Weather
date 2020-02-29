//
//  ViewController.swift
//  Weather
//
//  Created by Joe on 26/02/20.
//  Copyright © 2020 Joe. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

//delegate
//protocal
class ViewController: UIViewController{

    let appid = "d2a65212b6b73ee09aae0b6a928a8646"
    let locationManager = CLLocationManager()
    let weather = Weather()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.requestLocation()
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
        print(lat,lon)
        
        let params = ["lat":"\(lat)","lon":"\(lon)","appid":appid]
        getWeather(params: params)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Fail to get location"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCity"{
            let vc = segue.destination as! SelectCityController
            vc.currentCity = weather.city
            vc.delegate = self
        }
    }
}

extension ViewController :CLLocationManagerDelegate,SelectCityDelegate {
    func didChangeCity(city:String) {
        let params = ["q":city, "appid":appid]
        getWeather(params: params)
    }
    
    
    func getWeather(params:[String:String]){
        AF.request("https://api.openweathermap.org/data/2.5/weather", parameters:params).responseJSON{ response in
            if let json = response.value{
                let weather = JSON(json)
                self.createWeather(weatherJSON: weather)
                self.updateUI()
            }
        }
    }
    
    func createWeather(weatherJSON:JSON){
        weather.city = weatherJSON["name"].stringValue
        weather.temp = Int(round(weatherJSON["main","temp"].doubleValue-273.15))
        weather.condition = weatherJSON["weather",0,"id"].intValue
    }
    
    func updateUI(){
        cityLabel.text = weather.city
        tempLabel.text = "\(weather.temp)˚"
        imageView.image = UIImage(named: weather.icon)
    }
}

