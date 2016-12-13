//
//  city.swift
//  fienlute-pset6
//
//  Created by Fien Lute on 09-12-16.
//  Copyright © 2016 Fien Lute. All rights reserved.
//

import Foundation

struct City {
    let cityName: String
    let country: String
    let temperature: String
    let forecast: String
    
    init(cityName: String, country: String, temperature: String, forecast: String) {
        self.cityName = cityName
        self.country = country
        self.temperature = temperature
        self.forecast = forecast
    }
    
}

