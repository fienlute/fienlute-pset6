//
//  SecondViewController.swift
//  fienlute-pset6
//
//  Created by Fien Lute on 08-12-16.
//  Copyright © 2016 Fien Lute. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [CityItem] = [] // --> var cities: Array<City> = Array<City>()
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    let ref = FIRDatabase.database().reference(withPath: "city-items")
    var cities: Array<City> = Array<City>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        // just one user can use this app
        user = User(uid: "FakeId", email: "travel@person.city")
        
        // 1
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [CityItem] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let cityItem = CityItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(cityItem)
                
            }
            
            // 5
            self.items = newItems
            self.tableView.reloadData()
            
        })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let cityItem = items[indexPath.row]
        
        cell.cityName.text = cityItem.name
        cell.detailTextLabel?.text = cityItem.addedByUser
        //cell.cityName.text = cities[indexPath.row].cityName
        //cell.countryName.text = cities[indexPath.row].country
        //cell.cityTemp.text = cities[indexPath.row].temperature
        //cell.cityForecast.text = cities[indexPath.row].forecast
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityItem = items[indexPath.row]
            cityItem.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2
        let cityItem = items[indexPath.row]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    // don't need
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // return cities found by search
    //        return cities.count
    //
    //    }
    //
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
    //
    //        cell.cityName.text = cities[indexPath.row].cityName
    //        cell.countryName.text = cities[indexPath.row].country
    //        cell.cityTemp.text = cities[indexPath.row].temperature
    //        cell.cityForecast.text = cities[indexPath.row].forecast
    //
    //        return cell
    //    }
    //
    
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }

    
    // get api
   @IBAction func searchaAction(_ sender: Any) {
    
    //
    let alert = UIAlertController(title: "City Item",
                                  message: "Add an Item",
                                  preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { _ in
                                    // 1
                                    guard let textField = alert.textFields?.first,
                                        let text = textField.text else { return }
                                    
                                    // 2
                                    var cityItem = CityItem(name: text,
                                                            addedByUser: self.user.email)
                                    // 3
                                    let cityItemRef = self.ref.child(text.lowercased())
                                    
                                    // 4
                                    cityItemRef.setValue(cityItem.toAnyObject())
                                    
                                    let newCity = cityItem.name.replacingOccurrences(of: " ", with: "+")
                                    
                                    let myURL = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(newCity)%2C%20nl%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" )
                                    
                                    var request = URLRequest(url:myURL!)
                                    self.APIrequest(request: request)
                                    
        }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
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

                            let appendCity = City(cityName: name, country: country, temperature: temperature, forecast: forecast)
                            self.cities.append(appendCity)
                            print(self.cities)
                            self.tableView.reloadData()
                            
                        } else {
                            
                            // alert geven
                            
                            let alert = UIAlertController(title: "error",
                                                          message: "We do not have the weather data for this place.",
                                                          preferredStyle: .alert)
                            return
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
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segueDetails" {
                if let indexWeather = tableView.indexPathForSelectedRow?.row {
                    let destination = segue.destination as? ThirdViewController
                    destination?.nameCity = self.cities[indexWeather].cityName
                    // print(self.cities[indexWeather].cityName)
                }
            }
    }
}

    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


