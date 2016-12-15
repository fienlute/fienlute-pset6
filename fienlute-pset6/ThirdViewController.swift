//
//  ThirdViewController.swift
//  fienlute-pset6
//
//  Created by Fien Lute on 12-12-16.
//  Copyright © 2016 Fien Lute. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var theCity: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityForecast: UILabel!
    @IBOutlet weak var citySunrise: UILabel!
    @IBOutlet weak var citySunset: UILabel!
    @IBOutlet weak var cityMaxTemp: UILabel!
    @IBOutlet weak var cityMinTemp: UILabel!
    
    var nameCity = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SEGUED", nameCity)
        
        let newCity = nameCity.replacingOccurrences(of: " ", with: "+")
        
        let myURL = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(newCity)%2C%20nl%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" )
        
        var request = URLRequest(url:myURL!)
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
                    
                    print(json)
                    
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
                            
                            self.theCity.text = name
                            self.countryName.text = country
                            self.cityTemp.text = temperature

                        } else {
                            // geef alert als de plaats niet bestaat of de data niet beschikbaar is
                            let alert = UIAlertController(title: "Alert", message: "We do not have the weather data for this place.", preferredStyle: UIAlertControllerStyle.alert)
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
