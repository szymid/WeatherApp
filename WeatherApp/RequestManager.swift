//
//  RequestManager.swift
//  WeatherApp_wakeUp
//
//  Created by Boguslaw Dawidow on 25.06.2016.
//  Copyright © 2016 Szymon Dawidow. All rights reserved.
//

import Foundation

enum WeatherType: String {
    case Current = "weather"
    case Forecast = "forecast"
}

class RequestManager : NSObject {

    let apiId = "fa68199045458e4cde07c2d602afce5c"
    let WEATHERcracow = "http://api.openweathermap.org/data/2.5/weather?q=Krakow&units=metric&appid=fa68199045458e4cde07c2d602afce5c"
    var currentWeather: [String : AnyObject]?

    enum URLfrom {
        case Coordinates
        case CityName
        case CityId
    }

    func makeWeatherUrlFrom(weatherType: WeatherType, latitude: Double, longitude: Double) -> String {
        
        return "http://api.openweathermap.org/data/2.5/\(weatherType.rawValue)?q=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiId)"
    }

func getCurrentWeatherFromCoordinates(latitude latitude: Double, longitude: Double) {
    
    let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiId)"
    print("Adres : \(urlString)")
    let urlAPI = NSURL(string: urlString)
    print(urlAPI)
    
    let  task = NSURLSession.sharedSession().dataTaskWithURL(urlAPI!)
    { (data, response, error) in
        if data != nil{
            do{
                let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.currentWeather = jsonObj
                })
                
                print(jsonObj)
                
            } catch{
                print(error)
            }
        }
    }
    task.resume()
    
}

}