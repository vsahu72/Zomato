//
//  RestaurentListViewModel.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import Foundation

class RestaurentListViewModel {
    
    var restaurents: [Restaurent]
    
    init() {
        self.restaurents = [Restaurent]()
    }
    
    func restaurentsViewModel(at index: Int) -> Restaurent {
        return self.restaurents[index]
    }
    
    var totalRestaurents : Int  {
        get{
            return self.restaurents.count
        }
    }
    
}

