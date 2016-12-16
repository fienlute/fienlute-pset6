//
//  ThirdViewController.swift
//  fienlute-pset6
//
//  Created by Fien Lute on 12-12-16.
//  Copyright © 2016 Fien Lute. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
 
    // MARK: Properties
    var detailCity = String()
    
    // MARK: Outlets
    @IBOutlet weak var theCity: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityForecast: UILabel!
    @IBOutlet weak var citySunrise: UILabel!
    @IBOutlet weak var citySunset: UILabel!
    @IBOutlet weak var dateRequest: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluesky.png")!)
        
        // Get the weather data from yahoo and put it in api function.
        let newCity = detailCity.replacingOccurrences(of: " ", with: "+")
        
        let myURL = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(newCity)%2C%20%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" )

            let request = URLRequest(url:myURL!)
            self.APIrequest(request: request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    func APIrequest(request: URLRequest) {
        URLSession.shared.dataTask(with: request as URLRequest!, completionHandler: { data, response, error in

            guard let data = data, error == nil else {
                print("error: the data could not be found")
                return
            }
            do {
                // Convert data to json.
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    // Get the right data out of the api.
                    DispatchQueue.main.async {
                        let query = json.value(forKey: "query") as! NSDictionary
                      
                        if let results = query.value(forKey: "results") as? NSDictionary {
                            
                            let channel = results.value(forKey: "channel") as! NSDictionary
                            let item = channel.value(forKey: "item") as! NSDictionary
                            let condition = item.value(forKey: "condition") as! NSDictionary
                            let temperatureF = condition.value(forKey: "temp") as! String
                            let temperatureC = Int(temperatureF)! - 32
                            let forecast = condition.value(forKey: "text") as! String
                            let location = channel.value(forKey: "location") as! NSDictionary
                            let name = location.value(forKey: "city") as! String
                            let country = location.value(forKey: "country") as! String
                            let astronomy = channel.value(forKey: "astronomy") as! NSDictionary
                            let sunrise = astronomy.value(forKey: "sunrise") as! String
                            let sunset = astronomy.value(forKey: "sunset") as! String
                            let date = condition.value(forKey: "date") as! String
                            
                            self.theCity.text = name
                            self.countryName.text = country
                            self.cityTemp.text = String(temperatureC) + " ºC"
                            self.cityForecast.text = forecast
                            self.citySunset.text = sunset
                            self.citySunrise.text = sunrise
                            self.dateRequest.text = date
                            
                        } else {
                            self.errorAlert(alertCase: "We couldn't find the data for this place.")
                        }
                    }
                } else {
                    self.errorAlert(alertCase: "Couldn't convert data to dictionary")
                    return
                }
            } catch {
                self.errorAlert(alertCase: "Couldn't convert data to JSON")
            }
        }).resume()
    }

    func errorAlert(alertCase: String) {
        let alert = UIAlertController(title: "Sorry", message: alertCase , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: {})
        self.present(alert, animated: true, completion: nil)
    }
}
