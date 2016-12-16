//
//  SecondViewController.swift
//  fienlute-pset6
//
//
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
 
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
                
        // When start is pressed the user is logged in with this fake email,
        // because there's only one user.
        user = User(uid: "FakeId", email: "travel@person.city")
        
        ref.observe(.value, with: { snapshot in
            var newItems: [CityItem] = []
            
            for item in snapshot.children {
                let cityItem = CityItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(cityItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /// Puts city item in label in tableview cell.
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
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }

    /// When "+" button is clicked, save user input in firebase.
    @IBAction func didTapAddButton(_ sender: Any) {
        
        let text = searchBar.text
        let characterSet = NSMutableCharacterSet()
        characterSet.formUnion(with: NSCharacterSet.decimalDigits)
        characterSet.addCharacters(in: "!@#$%^&*()_+}{[]:|;'?/><,.±§")
        
        if searchBar.text == "" || text?.rangeOfCharacter(from: characterSet as CharacterSet) != nil {
            errorAlert(alertCase: "You need to add a (valid) city")
        } else {
            let text = searchBar.text
            let cityItem = CityItem(name: text!,
                                    addedByUser: self.user.email)
            let cityItemRef = self.ref.child((text?.lowercased())!)
            
            cityItemRef.setValue(cityItem.toAnyObject())
            
            searchBar.text = ""
        }
    }
        
    /// Get information from second to third viewcontroller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetails" {

            if let indexWeather = tableView.indexPathForSelectedRow?.row {
                let destination = segue.destination as? ThirdViewController
                destination?.detailCity = self.items[indexWeather].name
            }
        }
    }
    
    /// Gives an alert when an error occurs.
    func errorAlert(alertCase: String) {
        let alert = UIAlertController(title: "Sorry", message: alertCase , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: State restoration
    override func encodeRestorableState(with coder: NSCoder) {
        
        if let search = searchBar.text {
            coder.encode(search, forKey: "search")
        }
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        searchBar.text = coder.decodeObject(forKey: "search") as! String?
        
        super.decodeRestorableState(with: coder)
        }
}


