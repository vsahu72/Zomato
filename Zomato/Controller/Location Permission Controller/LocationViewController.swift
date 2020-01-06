//
//  LocationViewController.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import UIKit
import CoreLocation

    protocol LocationActions: class {
        func didLocationFound(location : CLLocationCoordinate2D)
    }
class LocationViewController: UIViewController {
    @IBOutlet weak var locationView: LocationView!
        weak var delegate: LocationActions?
        let locationService = LocationService()
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            locationView.didTapAllow = {
                self.locationService.requestLocationAuthorization()
            }
                
            locationService.didChangeStatus = {
                [weak self] success in
                    if success {
                    self?.locationService.getLocation()
                }
            }
                
            locationService.newLocation = {
                [weak self] result in
                    switch result {
                    case .success(let location):
                        self?.dismiss(animated: true, completion: nil)
                        self?.delegate?.didLocationFound(location: location.coordinate)
                        case .failure(let error):
                    assertionFailure("Error getting the users location \(error)")
                }
            }
        }
    
}


