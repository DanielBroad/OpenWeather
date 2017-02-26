//
//  ViewController.swift
//  OpenWeather
//
//  Created by Daniel Broad on 26/02/2017.
//  Copyright © 2017 Dorada App Software Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var forecastDays : [ForecastDay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let forecastController = ForecastController(networkController: NetworkController())
        forecastController.getForecast { [weak self] (networkforcast, error) in
            guard let `self` = self else { return }
            if let networkforcast = networkforcast {
                self.forecastDays = networkforcast
            } else if let error = error {
                SimpleAlert.show(fromViewController: self, title: error.localizedDescription, message: nil)
            }
        }
    }


}

