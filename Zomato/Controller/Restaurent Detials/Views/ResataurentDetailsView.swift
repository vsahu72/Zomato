//
//  ResataurentDetailsView.swift
//  Zomato
//
//  Created by vikash sahu on 05/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class ResataurentDetailsView: UIView {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var averageCostLabel: UILabel?
    @IBOutlet weak var hoursLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var ratingsLabel: UILabel?
    @IBOutlet weak var webUrlLabel: UILabel?
    @IBOutlet weak var votesLabel: UILabel?
    @IBOutlet weak var cuisinesLabel: UILabel?
    @IBOutlet weak var mapView: MKMapView?

    @IBAction func showAllUserReview(_ sender: Any) {

    }
    
    @IBAction func showWebUrlInSafari(_ sender: Any) {
        if let url = URL(string: webUrlLabel!.text!) {
            UIApplication.shared.open(url)
        }
    }

}
