//
//  UIViewController+Extension.swift
//  Zomato
//
//  Created by vikash sahu on 05/01/20.
//  Copyright © 2020 Aripra. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showInternetUnavailbleAlert() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
}
