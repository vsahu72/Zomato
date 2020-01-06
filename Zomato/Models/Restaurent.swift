//
//  Restaurent.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurent: Decodable {
    
    var id : String?
    var name : String?
    var url : String?
    var thumb : String?
    var user_rating : Rating
    var location : Location
    var cuisines : String?
    var timings : String?
    var average_cost_for_two : Int32?
    
    init() {
        id = ""
        name = ""
        url = ""
        thumb = ""
        user_rating = Rating()
        location = Location()
    }
}

struct Location: Decodable {
    
    var address : String
    var locality : String
    var city : String
    var latitude : String
    var longitude : String
    var zipcode : String
    var locality_verbose : String
    
    init() {
        address = ""
        locality = ""
        city = ""
        latitude = ""
        longitude = ""
        zipcode = ""
        locality_verbose = ""
    }
}

struct NearbyRestaurantList : Decodable {
    
    var nearby_restaurants : [NearbyRestaurant]
}

struct NearbyRestaurant : Decodable{
    var restaurant : Restaurent
}

struct Rating : Decodable {
    var aggregate_rating : String
    var votes : String
    init() {
        aggregate_rating = ""
        votes = ""
    }
}


extension Restaurent {
    
    static func allNearbyRestaurentList(location: CLLocationCoordinate2D) -> Resource<NearbyRestaurantList?> {
        guard let url = URL(string: "https://developers.zomato.com/api/v2.1/geocode?lat=\(location.latitude)&lon=\(location.longitude)") else {
            fatalError("URL is incorrect!")
        }
        return Resource<NearbyRestaurantList?>(url: url)
    }
    
    static func detailsOfRestaurent(restaurentId: String) -> Resource<Restaurent?> {
        guard let url = URL(string: "https://developers.zomato.com/api/v2.1/restaurant?res_id=\(restaurentId)") else {
            fatalError("URL is incorrect!")
        }
        return Resource<Restaurent?>(url: url)
    }
    
}
