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
    var items: [CityItem] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    let ref = FIRDatabase.database().reference(withPath: "city-items")
    // var cities: Array<City> = Array<City>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!

    // get api
   @IBAction func searchaAction(_ sender: Any) {
    
    let alert = UIAlertController(title: "Grocery Item",
                                  message: "Add an Item",
                                  preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { _ in
                                    // 1
                                    guard let textField = alert.textFields?.first,
                                        let text = textField.text else { return }
                                    
                                    // 2
                                    let cityItem = CityItem(name: text,
                                                            addedByUser: self.user.email)
                                    // 3
                                    let cityItemRef = self.ref.child(text.lowercased())
                                    
                                    // 4
                                    cityItemRef.setValue(cityItem.toAnyObject())
    }
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
    }
//        let newCity = searchBar.text!.replacingOccurrences(of: " ", with: "+")
//
//        let myURL = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(newCity)%2C%20nl%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys" )
//        
//        let request = URLRequest(url:myURL!)
//        print(request)
//        
//        URLSession.shared.dataTask(with: myURL!, completionHandler: { data, response, error in
//            
//            // guards execute when the condition is NOT met.
//            guard let data = data, error == nil else {
//                print("error: the data could not be found")
//                
//                return
//            }
//            do {
//                // Convert data to json.
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                    
//                    print(json)
//                    
//                    DispatchQueue.main.async {
//                        let query = json.value(forKey: "query") as! NSDictionary
//                        
//                        if let results = query.value(forKey: "results") as? NSDictionary {
//        
//                            let channel = results.value(forKey: "channel") as! NSDictionary
//                            let item = channel.value(forKey: "item") as! NSDictionary
//                            let condition = item.value(forKey: "condition") as! NSDictionary
//                            let temperature = condition.value(forKey: "temp") as! String
//                            let forecast = condition.value(forKey: "text") as! String
//                            let location = channel.value(forKey: "location") as! NSDictionary
//                            let name = location.value(forKey: "city") as! String
//                            let country = location.value(forKey: "country") as! String
//
//                            let appendCity = City(cityName: name, country: country, temperature: temperature, forecast: forecast)
//                            self.cities.append(appendCity)
//                            print(self.cities)
//                            self.tableView.reloadData()
//                            
//                        } else {
//                            
//                            // alert geven
//                        }
//                        
//                    }
//                } else {
//                    print("convert error")
//                    return
//                }
//                
//            } catch {
//                print ("error")
//            }
//        }).resume()
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [CityItem] = []
            
            for item in snapshot.children {
                let cityItem = CityItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(cityItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        user = User(uid: "FakeId", email: "hungry@person.food")
    
    
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let cityItem = items[indexPath.row]
        
        cell.textLabel?.text = cityItem.name
        cell.detailTextLabel?.text = cityItem.addedByUser
        
//        toggleCellCheckbox(cell, isCompleted: CityItem.completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2
        let groceryItem = items[indexPath.row]
        // 3
//        let toggledCompletion = !CityItem.completed
        // 4
//        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//        // 5
//        groceryItem.ref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
}

    
    
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "segueDetails" {
//                if let indexWeather = tableView.indexPathForSelectedRow?.row {
//                    let destination = segue.destination as? ThirdViewController
//                    destination?.nameCity = self.cities[indexWeather].cityName
//                    // print(self.cities[indexWeather].cityName)
//                }
//            }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


