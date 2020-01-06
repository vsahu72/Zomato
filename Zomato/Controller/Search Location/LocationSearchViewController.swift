//
//  LocationSearchViewController.swift
//  Zomato
//
//  Created by vikash sahu on 05/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//
import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
protocol LocationSearchViewDelegate : class {
    func didSelectCustomLocation(location : CLLocationCoordinate2D)
}

class LocationSearchViewController : UIViewController {
    
    var selectedPin:MKPlacemark? = nil
    weak var delegate : LocationSearchViewDelegate?
    
    var resultSearchController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        //resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    @IBAction func doneButtonPress(sender : Any){
        guard let location = selectedPin?.coordinate else{
            self.navigationController?.popViewController(animated: true)
            return
        }
        delegate!.didSelectCustomLocation(location: location)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension LocationSearchViewController : CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:: \(error.localizedDescription)")
       }

       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if status == .authorizedWhenInUse {
               locationManager.requestLocation()
           }
       }

       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

           if let location = locations.first {
               let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
               let region = MKCoordinateRegion(center: location.coordinate, span: span)
               mapView.setRegion(region, animated: true)
           }

       }
    
}

extension LocationSearchViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion.init(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension LocationSearchViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: Selector(("getDirections")), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
