//
//  SecondViewController.swift
//  fienlute-pset6
//
//  Created by Fien Lute on 08-12-16.
//  Copyright © 2016 Fien Lute. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cities: Array<City> = Array<City>()
    // var cities: []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchaAction(_ sender: Any) {
        let newCity = searchBar.text!.replacingOccurrences(of: " ", with: "+")
        
        let myURL = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(newCity)%2C%20nl%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" )
        
        let request = URLRequest(url:myURL!)
        print(request)
        
        URLSession.shared.dataTask(with: myURL!, completionHandler: { data, response, error in
            
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

                            let appendCity = City(cityName: name, country: country, temperature: temperature, forecast: forecast)
                            self.cities.append(appendCity)
                            print(self.cities)
                            self.tableView.reloadData()
                            
                        } else {
                            
                            // alert geven
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return cities found by search
        return cities.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.cityName.text = cities[indexPath.row].cityName
        cell.countryName.text = cities[indexPath.row].country
        cell.cityTemp.text = cities[indexPath.row].temperature
        cell.cityForecast.text = cities[indexPath.row].forecast
        
        return cell
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segueDetails" {
                if let indexWeather = tableView.indexPathForSelectedRow?.row {
                    let destination = segue.destination as? ThirdViewController
                    destination?.nameCity = self.cities[indexWeather].cityName
                    // print(self.cities[indexWeather].cityName)
                }
            }
        }
        
//        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//            if segue.identifier == "segueDetail", let destination = segue.destination as? ThirdViewController {
//                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
//                    let cityName = cities[indexPath.row]
//                    ThirdViewController.city = cityName.text
//                }
//            }
//        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
