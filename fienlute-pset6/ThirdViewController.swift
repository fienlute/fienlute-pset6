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
        
        // set background to image
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluesky.png")!)
        
        // get the weather data from yahoo and put it in api function
        let newCity = detailCity.replacingOccurrences(of: " ", with: "+")
        
        let myURL = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(newCity)%2C%20%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" )

            let request = URLRequest(url:myURL!)
            self.APIrequest(request: request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func APIrequest(request: URLRequest) {
        URLSession.shared.dataTask(with: request as URLRequest!, completionHandler: { data, response, error in
            
            // guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                print("error: the data could not be found")
                return
            }
            do {
                // Convert data to json.
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    // get the right data out of the api
                    DispatchQueue.main.async {
                        let query = json.value(forKey: "query") as! NSDictionary
                      
                        if let results = query.value(forKey: "results") as? NSDictionary {
                            
                            let channel = results.value(forKey: "channel") as! NSDictionary
                            let item = channel.value(forKey: "item") as! NSDictionary
                            let condition = item.value(forKey: "condition") as! NSDictionary
                            let temperature = condition.value(forKey: "temp") as! String
                            let forecast = condition.value(forKey: "text") as! String
                            let location = channel.value(forKey: "location") as! NSDictionary
                            let name = location.value(forKey: "city") as! String
                            let country = location.value(forKey: "country") as! String
                            let astronomy = channel.value(forKey: "astronomy") as! NSDictionary
                            let sunrise = astronomy.value(forKey: "sunrise") as! String
                            let sunset = astronomy.value(forKey: "sunset") as! String
                            let date = condition.value(forKey: "date") as! String
                            
                            // put api data into the right label
                            self.theCity.text = name
                            self.countryName.text = country
                            self.cityTemp.text = temperature + " F"
                            self.cityForecast.text = forecast
                            self.citySunset.text = sunset
                            self.citySunrise.text = sunrise
                            self.dateRequest.text = date

                        // alert when data is not available
                        } else {
                            let alert = UIAlertController(title: "Sorry", message: "We cannot find the weather data for this place.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                } else {
                    print("convert error")
                    return
                }
                
            } catch {
                print ("error")
            }
        }).resume()
    }
}
