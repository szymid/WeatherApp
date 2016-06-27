//
//  ViewController.swift
//  WeatherApp_wakeUp
//
//  Created by Boguslaw Dawidow on 08.05.2016.
//  Copyright © 2016 Szymon Dawidow. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherIconImage.image = UIImage(named: "sun_white")
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func getWeatherDataFrom(urlString: String) {
        print("Adres : \(urlString)")
        let urlAPI = NSURL(string: urlString)
        print(urlAPI)
        
        let  task = NSURLSession.sharedSession().dataTaskWithURL(urlAPI!)
            { (data, response, error) in
                if data != nil{
                    do{
                        let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                        
                        let cityName = jsonObj["name"] as! String
                        
                        let jsonArray = jsonObj["weather"] as! Array<NSDictionary>
                        let weatherDict = jsonArray.first
                        //let descriptionWeather = weatherDict!["description"] as! String
                        let iconName = weatherDict!["icon"] as! String
                        let mainDict = jsonObj["main"] as! [String:AnyObject]
                        let temp = mainDict["temp"] as! Float
                        let minTemp = mainDict["temp_min"] as! Float
                        let maxTemp = mainDict["temp_max"] as! Float
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            self.cityNameLabel.text = cityName
                            //self.weatherNameLabel.text = descriptionWeather
                            self.tempLabel.text = " \(Int(temp))°"
                            self.minTempLabel.text = "\(Int(minTemp))°"
                            self.maxTempLabel.text = "\(Int(maxTemp))°"
                            self.weatherIconImage.image = UIImage(named: "\(iconName).png")
                            
                            let color = self.getColorFromIconName(iconName)
                            self.tempLabel.textColor = color
                            self.iconBackgroundView.backgroundColor = color
                        })

                        print(jsonObj)
                        
                    } catch{print(error)}
                }
            }
            task.resume()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Location Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.getWeatherDataFrom("http://api.openweathermap.org/data/2.5/weather?lat=\(center.latitude)&lon=\(center.longitude)&units=metric&lang=pl&appid=fa68199045458e4cde07c2d602afce5c")
            
            print(center.latitude, center.longitude)
        }
        
    }
    
    //MARK: - Color methods
    
    func getColorFromIconName(name: String) -> UIColor{
        let index = name.endIndex.advancedBy(-1)
        let iconString = name.substringToIndex(index)
        let iconNumber = Int(iconString)
        
        switch iconNumber! {
        case 1,2:
            return UIColor(red: 255/255.0, green: 170/255.0, blue: 144/255.0, alpha: 0.8)
        default:
            return UIColor(red: 68/255.0, green: 89/255.0, blue: 99/255.0, alpha: 0.8)
            
        }
    }
}

