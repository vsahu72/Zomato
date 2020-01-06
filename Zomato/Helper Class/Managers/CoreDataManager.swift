//
//  CoreDataManager.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(moc: NSManagedObjectContext.current)
    
    var moc: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    private func fetchRestaurentCD(id: String) -> RestaurentCD? {
        
        var retaurentCD = [RestaurentCD]()
        
        let request: NSFetchRequest<RestaurentCD> = RestaurentCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            retaurentCD = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return retaurentCD.first
        
    }
    
    private func fetchLocationCD(id: String) -> LocationCD? {
        
        var locationCD = [LocationCD]()
        
        let request: NSFetchRequest<LocationCD> = LocationCD.fetchRequest()
        request.predicate = NSPredicate(format: "restaurentId == %@", id)
        
        do {
            locationCD = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return locationCD.first
        
    }
    
    private func fetchRatingCD(id: String) -> RatingCD? {
        
        var ratingCD = [RatingCD]()
        
        let request: NSFetchRequest<RatingCD> = RatingCD.fetchRequest()
        request.predicate = NSPredicate(format: "restaurentId == %@", id)
        
        do {
            ratingCD = try self.moc.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        return ratingCD.first
        
    }
    
    private func fetchAllRestaurents() -> [RestaurentCD] {
        
        var restaurentsCD = [RestaurentCD]()
        
        let restaurentsCDRequest: NSFetchRequest<RestaurentCD> = RestaurentCD.fetchRequest()
        
        do {
            restaurentsCD = try self.moc.fetch(restaurentsCDRequest)
        } catch let error as NSError {
            print(error)
        }
        
        return restaurentsCD
        
    }
    
    func deleteAllRecordsFromTable(tableName : String) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try self.moc.execute(deleteRequest)
            try self.moc.save()
        } catch {
            print ("There was an error on deleating \(tableName)")
        }
    }
    
    func deleteAllRecords() {
        deleteAllRecordsFromTable(tableName: "RestaurentCD")
        deleteAllRecordsFromTable(tableName: "LocationCD")
        deleteAllRecordsFromTable(tableName: "RatingCD")
    }
    
    func saveRestaurentCD(restaurent : Restaurent) {
        
        let restaurentCD = RestaurentCD(context: self.moc)
        restaurentCD.id = restaurent.id
        restaurentCD.name = restaurent.name
        restaurentCD.url = restaurent.url
        restaurentCD.thumb = restaurent.thumb
        restaurentCD.cuisines = restaurent.cuisines ?? ""
        restaurentCD.timings = restaurent.timings ?? ""
        restaurentCD.average_cost_for_two = restaurent.average_cost_for_two ?? 0
        do {
            try self.moc.save()
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func saveLocationCD(restaurent : Restaurent) {
        
        let locationCD = LocationCD(context: self.moc)
        locationCD.restaurentId = restaurent.id
        locationCD.address = restaurent.location.address
        locationCD.locality = restaurent.location.locality
        locationCD.latitude = restaurent.location.latitude
        locationCD.longitude = restaurent.location.longitude
        locationCD.zipcode = restaurent.location.zipcode
        locationCD.city = restaurent.location.city
        locationCD.locality_verbose = restaurent.location.locality_verbose
        
        do {
            try self.moc.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func saveRatingCD(restaurent : Restaurent) {
        
        let ratingCD = RatingCD(context: self.moc)
        ratingCD.restaurentId = restaurent.id
        ratingCD.aggregate_rating = restaurent.user_rating.aggregate_rating
        ratingCD.votes = restaurent.user_rating.votes
        
        do {
            try self.moc.save()
        } catch let error as NSError {
            print(error)
        }
    }
    func saveAllRestaurentListInformation(restaurents : [Restaurent]){
        
        for restaurent in restaurents{
            saveRestaurentCD(restaurent: restaurent)
            saveLocationCD(restaurent: restaurent)
            saveRatingCD(restaurent: restaurent)
        }
    }
    
    func getAllRestaurentListInformation() -> [Restaurent]{
        var restaurents = [Restaurent]()
        
        let restaurentsCD = fetchAllRestaurents()
        
        for restaurentCD in restaurentsCD{
            var tempRestaurent = Restaurent()
            
            tempRestaurent.id = restaurentCD.id
            tempRestaurent.name = restaurentCD.name
            tempRestaurent.url = restaurentCD.url
            tempRestaurent.thumb = restaurentCD.thumb
            tempRestaurent.cuisines = restaurentCD.cuisines
            tempRestaurent.timings = restaurentCD.timings
            tempRestaurent.average_cost_for_two = restaurentCD.average_cost_for_two
            
            if let location = fetchLocationCD(id: restaurentCD.id!){
                tempRestaurent.location.address = location.address!
                tempRestaurent.location.locality = location.locality!
                tempRestaurent.location.city = location.city!
                tempRestaurent.location.latitude = location.latitude!
                tempRestaurent.location.longitude = location.longitude!
                tempRestaurent.location.zipcode = location.zipcode!
                tempRestaurent.location.locality_verbose = location.locality_verbose!
            }
            
            if let rating = fetchRatingCD(id: restaurentCD.id!) {
                tempRestaurent.user_rating.aggregate_rating = rating.aggregate_rating!
                tempRestaurent.user_rating.votes = rating.votes!
                
            }
            restaurents.append(tempRestaurent)
        }
        return restaurents
    }
    
    
}
