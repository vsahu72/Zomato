//
//  RestaurentTableViewController.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class RestaurentTableViewController: UITableViewController ,LocationActions,UISearchBarDelegate,LocationSearchViewDelegate {
    
    var restaurentListViewModel = RestaurentListViewModel()
    var filterRestaurentListViewModel = RestaurentListViewModel()
    var locationSearchViewController : LocationSearchViewController?
    var restaurentDetailViewController : RestaurentDetailViewController?
    var loactionServices = LocationService()
    var currentLocation : CLLocationCoordinate2D?
    @IBOutlet weak var changeLocationGuideView: UIView!
    
    @IBOutlet weak var cityNameBarButtonOutlet : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        checkLocationStatus()
    }
    
    
    @objc func statusManager(_ notification: Notification) {
        if restaurentListViewModel.totalRestaurents <= 1{
             loadRestaurentsFromInternet()
        }
       
    }
    
    @IBAction func cityNameBarButtonAction(sender : Any){
        if(!Reachability.isConnectedToNetwork()){
            self.showInternetUnavailbleAlert()
            return
        }
        showSearchLocationViewController()
    }
    
    @IBAction func placeIconBarButtonAction(sender : Any){
        if(!Reachability.isConnectedToNetwork()){
            self.showInternetUnavailbleAlert()
            return
        }
        showSearchLocationViewController()
    }
    
    func checkLocationStatus(){
        switch self.loactionServices.status {
        case .notDetermined, .denied, .restricted:
            print("location permission status \(self.loactionServices.status) ")
            showLocationViewController()
        default:
            print("Already allow Location permission")
            populateRestaurents()
        }
    }
    
    private func populateRestaurents() {
        
        if let _ = UserDefaults.standard.string(forKey: "CityName"){
            loadRestaurentsFromLocalDataBase()
        }else{
            loadRestaurentsFromInternet()
        }
    }
    
    func loadRestaurentsFromInternet(){
        
        if(!Reachability.isConnectedToNetwork()){
            self.showInternetUnavailbleAlert()
            return
        }
        guard let location = currentLocation else{
            print("Current Location not found")
            return;
        }
        
        let resource = Restaurent.allNearbyRestaurentList(location: location)
        
        Webservice().load(resource: resource) { [weak self] result in
            
            switch result {
            case .success(let result):
                self?.restaurentListViewModel.restaurents = result!.nearby_restaurants.map{$0.restaurant}
                Utils.saveCityName(restaurent:(self?.restaurentListViewModel.restaurents.first)!)
                
                CoreDataManager.shared.deleteAllRecords(); CoreDataManager.shared.saveAllRestaurentListInformation(restaurents: (self?.restaurentListViewModel.restaurents)!)
                self?.filterRestaurentListViewModel.restaurents = (self?.restaurentListViewModel.restaurents)!
                self?.setCityNameBarButtonTitle(restaurent: (self?.restaurentListViewModel.restaurents.first)!)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setCityNameBarButtonTitle(restaurent : Restaurent){
        guard let cityName = Utils.getCityName(restaurent: restaurent) else{
            return
        }
        cityNameBarButtonOutlet.title = cityName
        
    }
    
    func loadRestaurentsFromLocalDataBase(){
        self.restaurentListViewModel.restaurents = CoreDataManager.shared.getAllRestaurentListInformation()
        self.filterRestaurentListViewModel.restaurents = self.restaurentListViewModel.restaurents
        setCityNameBarButtonTitle(restaurent: self.restaurentListViewModel.restaurents.first!)
        self.tableView.reloadData()
    }
    
    func showLocationViewController(){
        
        let locationViewController = (self.storyboard?.instantiateViewController(identifier: "LocationViewController"))! as LocationViewController
        locationViewController.delegate = self
        locationViewController.modalPresentationStyle = .fullScreen
        self.present(locationViewController, animated: false, completion: nil);
    }
    
    func showSearchLocationViewController(){
        
        if(locationSearchViewController == nil){
            locationSearchViewController = (self.storyboard?.instantiateViewController(identifier: "LocationSearchViewController"))! as LocationSearchViewController
            locationSearchViewController!.delegate = self
        }
        self.navigationController?.pushViewController(locationSearchViewController!, animated: true)
        
    }
    
    func showRestaurentDetailViewController(with restaurent: Restaurent){
        if(restaurentDetailViewController == nil){
            restaurentDetailViewController = (self.storyboard?.instantiateViewController(identifier: "RestaurentDetailViewController"))! as RestaurentDetailViewController
        }
        let viewModel = RestaurentDetailViewModel(restaurent: restaurent); restaurentDetailViewController?.viewModel = viewModel; self.navigationController?.pushViewController(restaurentDetailViewController!, animated: true)
        
    }
    
    func didSelectCustomLocation(location: CLLocationCoordinate2D) {
        currentLocation = location
        loadRestaurentsFromInternet()
    }
    
    func didLocationFound(location: CLLocationCoordinate2D) {
        currentLocation = location
        populateRestaurents()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        filterRestaurentListViewModel.restaurents = searchText.isEmpty ? restaurentListViewModel.restaurents : restaurentListViewModel.restaurents.filter({(restaurent: Restaurent) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return restaurent.name!.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filterRestaurentListViewModel.totalRestaurents
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let restaurent = self.filterRestaurentListViewModel.restaurentsViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
        cell.configure(with: restaurent)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let restaurent = self.filterRestaurentListViewModel.restaurentsViewModel(at: indexPath.row)
        showRestaurentDetailViewController(with: restaurent)
    }
    
}


