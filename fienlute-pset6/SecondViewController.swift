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
        //cell.countryName.text = cityItem.country
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
                                    
        }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
    }
    

        
    // get information from second to third viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetails" {
//            print("ELEMTS IN ARRAY", self.cities.count)
//            print("ROWINDEX", tableView.indexPathForSelectedRow?.row )
            
            if let indexWeather = tableView.indexPathForSelectedRow?.row {
                let destination = segue.destination as? ThirdViewController
                destination?.nameCity = self.items[indexWeather].name
                //print(self.cities[indexWeather].cityName)
            }
        }
    }
}


