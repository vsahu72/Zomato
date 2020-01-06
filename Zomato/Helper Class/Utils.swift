//
//  Utils.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import Foundation

class Utils {
    
    static func saveCityName(restaurent : Restaurent) {
        UserDefaults.standard.set(restaurent.location.city, forKey: "CityName")
    }
    
    static func getCityName(restaurent : Restaurent) -> String? {
        return UserDefaults.standard.string(forKey: "CityName")
    }
}
