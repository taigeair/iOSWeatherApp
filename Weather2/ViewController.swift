//
//  ViewController.swift
//  Weather2
//
//  Created by Taige Zhang on 15/08/2015.
//  Copyright (c) 2015 Taige Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var responseWeather: UILabel!
    
    @IBOutlet weak var userCity: UITextField!
    
    var weatherReport = ""
    
    func showError(){
        if userCity.text == nil{
            responseWeather.text = "Please enter a city."
        } else {
        responseWeather.text = "Was not able to find weather for " + userCity.text + ". Please retry."
        }
    }
    

    @IBAction func getWeather(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        var cleanString = userCity.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + cleanString.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if url != nil{
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data,response,error) -> Void in
                
                var urlError = false
                
                if error == nil {
                    
                    var urlContent = NSString(data: data , encoding: NSUTF8StringEncoding) as NSString!
                    var weather = urlContent.componentsSeparatedByString("<span class=\"phrase\">") as NSArray
                    
                    if weather.count > 1{
                        var weatherPhrase = weather[1].componentsSeparatedByString("</span>")
                        self.weatherReport = weatherPhrase[0] as! String
                        
                        self.weatherReport = self.weatherReport.stringByReplacingOccurrencesOfString("&deg;", withString: "˚")
                        var weatherReportTemp = NSString(string: self.weatherReport)
                        var firstChar = weatherReportTemp.substringToIndex(1)
                        firstChar = firstChar.lowercaseString
                        weatherReportTemp = weatherReportTemp.substringFromIndex(1)
                        

                        
                        self.weatherReport = "The weather in " + cleanString + " is " + (firstChar as String) + (weatherReportTemp as String)

                        
                        println(self.weatherReport)
                    } else {
                        urlError = true
                    }
                    
                    
                } else {
                    urlError = true
                    println("error")
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    if urlError == true{
                        self.showError()
                    } else {
                        self.responseWeather.text = self.weatherReport
                    }
                    
                }
            })
            
            task.resume()
            
        } else {
            
            showError()
            
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.userCity.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        getWeather(self)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
    }
    
}

