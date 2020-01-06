//
//  RestaurentDetailViewModel.swift
//  Zomato
//
//  Created by vikash sahu on 05/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import Foundation
import CoreLocation

class RestaurentDetailViewModel {
    
    var id : String
    var name : String
    var url : String
    var thumbURL : String
    var cuisines : String?
    var timings : String?
    var averageCost : Int32?
    private var lattitude : String
    private var longitude : String
    var aggregate_rating : String
    var votes : String
    var address : String
    
    var location : CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D.init(latitude: Double(lattitude)!, longitude: Double(longitude)!)
        }
    }
    
    init(restaurent : Restaurent) {
        id = restaurent.id!
        name = restaurent.name!
        url = restaurent.url!
        thumbURL = restaurent.thumb!
        cuisines = restaurent.cuisines
        timings = restaurent.timings
        averageCost = restaurent.average_cost_for_two
        lattitude = restaurent.location.latitude
        longitude = restaurent.location.longitude
        aggregate_rating = restaurent.user_rating.aggregate_rating
        votes = restaurent.user_rating.votes
        address = restaurent.location.address
        
    }
}
