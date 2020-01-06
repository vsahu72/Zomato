//
//  LocationView.swift
//  Zomato
//
//  Created by vikash sahu on 04/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import UIKit

@IBDesignable class LocationView: UIView {

    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!

    var didTapAllow: (() -> Void)?

    @IBAction func allowAction(_ sender: UIButton) {
        didTapAllow?()
    }

    @IBAction func denyAction(_ sender: UIButton) {

    }
}
