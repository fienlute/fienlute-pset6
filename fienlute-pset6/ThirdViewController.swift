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
    
    var nameCity = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.theCity.text = nameCity
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.theCity.text = nameCity
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
