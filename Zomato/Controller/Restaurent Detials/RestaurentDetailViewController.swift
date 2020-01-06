//
//  RestaurentDetailViewController.swift
//  Zomato
//
//  Created by vikash sahu on 05/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestaurentDetailViewController: UIViewController {
    @IBOutlet weak var restaurentDetailView: ResataurentDetailsView?
    var viewModel: RestaurentDetailViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let resource = Restaurent.detailsOfRestaurent(restaurentId: viewModel!.id)
        Webservice().load(resource: resource) { result in
            switch result {
            case .success(let result):
                self.updateViewAfterAPICalling(restaurentDetail: result!)
                print("details of restaurent.. = \(String(describing: result))")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateViewAfterAPICalling(restaurentDetail : Restaurent){
        restaurentDetailView?.hoursLabel?.text = restaurentDetail.timings
        restaurentDetailView?.cuisinesLabel?.text = restaurentDetail.cuisines
        restaurentDetailView?.averageCostLabel?.text = "Rs. \(restaurentDetail.average_cost_for_two!)"
        
    }
    
    func updateView() {
        if let viewModel = viewModel {
            restaurentDetailView?.addressLabel?.text = viewModel.address
            restaurentDetailView?.ratingsLabel?.text = viewModel.aggregate_rating
            restaurentDetailView?.webUrlLabel?.text = viewModel.url
            restaurentDetailView?.votesLabel?.text = "\(viewModel.votes) votes"
            restaurentDetailView?.imageView!.loadImageUsingCache(withUrl: viewModel.thumbURL)
            
            centerMap(for: viewModel.location)
            title = viewModel.name
        }
    }
    
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        restaurentDetailView?.mapView?.addAnnotation(annotation)
        restaurentDetailView?.mapView?.setRegion(region, animated: true)
    }
}


