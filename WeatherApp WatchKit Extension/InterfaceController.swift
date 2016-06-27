//
//  InterfaceController.swift
//  WeatherApp_wakeUp WatchKit Extension
//
//  Created by Boguslaw Dawidow on 08.05.2016.
//  Copyright © 2016 Szymon Dawidow. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var weatherIconImage: WKInterfaceImage!
    @IBOutlet var tempLabel: WKInterfaceLabel!
    @IBOutlet var cityNameLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.getWeatherDataFrom("http://api.openweathermap.org/data/2.5/weather?q=Krakow&units=metric&appid=fa68199045458e4cde07c2d602afce5c")                       
    }

    override func didDeactivate() {
        // This meth od is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getWeatherDataFrom(urlString: String) {
        
        let urlAPI = NSURL(string: urlString)
        
        let  task = NSURLSession.sharedSession().dataTaskWithURL(urlAPI!)
        { (data, response, error) in
            if data != nil{
                do{
                    let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                    
                    let jsonArray = jsonObj["weather"] as! Array<NSDictionary>
                    let weatherDict = jsonArray.first
                    
                    let mainDict = jsonObj["main"] as! [String:AnyObject]
                    let temp = mainDict["temp"] as! Float
                    let cityName = jsonObj["name"] as! String
                    let iconName = weatherDict!["icon"] as! String
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.tempLabel.setText( "\(Int(temp))°")
                        self.cityNameLabel.setText(cityName)
                        self.weatherIconImage.setImage(UIImage(named: "\(iconName).png"))
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
