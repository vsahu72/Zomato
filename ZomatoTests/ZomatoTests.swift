//
//  ZomatoTests.swift
//  ZomatoTests
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Zomato

class ZomatoTests: XCTestCase {

    func test_For_Fetching_AllNearbyRestaurentList() {
        let location = CLLocationCoordinate2D.init(latitude: 22.7196, longitude: 75.8577)
        let expectation = XCTestExpectation.init(description: " Get All Nearby restaurent")
        let resource = Restaurent.allNearbyRestaurentList(location: location)
        Webservice().load(resource: resource) { result in
            switch result {
            case .success:
             expectation.fulfill()
            case .failure:
                 XCTFail("Fail")
            }
        }
           
    }
    
    func test_For_Fetching_Details_Of_Restaurent() {
            let restaurentId = "18430785"
           let expectation = XCTestExpectation.init(description: " Get Details of restaurent By restaurent Id")
           let resource = Restaurent.detailsOfRestaurent(restaurentId: restaurentId)
           Webservice().load(resource: resource) { result in
               switch result {
               case .success:
                expectation.fulfill()
               case .failure:
                    XCTFail("Fail")
               }
           }
              
       }

   

}
