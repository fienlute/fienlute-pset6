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
 
    // MARK: Outlets
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
        
        // when start is pressed the user is logged in with this fake email
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // puts city item in label in tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let cityItem = items[indexPath.row]
        
        cell.cityName.text = cityItem.name
        
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
    
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }

    // when "+" button is clicked, save user input in firebase
    @IBAction func didTapAddButton(_ sender: Any) {
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

            if let indexWeather = tableView.indexPathForSelectedRow?.row {
                let destination = segue.destination as? ThirdViewController
                destination?.detailCity = self.items[indexWeather].name
            }
        }
    }
}


