//
//  RestaurantTableViewCell.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = UIColor.red
        } else {
            contentView.backgroundColor = UIColor.white
        }
    }
    

    func configure(with restaurentModel: Restaurent) {
        addressLabel.text = restaurentModel.location.locality_verbose
        restaurantNameLabel.text = restaurentModel.name
        ratingLabel.text = restaurentModel.user_rating.aggregate_rating
        restaurantImageView.loadImageUsingCache(withUrl: restaurentModel.thumb!)
    }

}

