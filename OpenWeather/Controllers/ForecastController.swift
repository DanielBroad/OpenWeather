//
//  ForecastController.swift
//  OpenWeather
//
//  Created by Daniel Broad on 26/02/2017.
//  Copyright © 2017 Dorada App Software Ltd. All rights reserved.
//
//  Populates the model from JSON

import Foundation

private struct APIDictionaryKey {
    static let Forecast = "list"
}

class ForecastController {
    
    var networkController : WeatherAPIRequests
    
    init(networkController _networkController: WeatherAPIRequests) {
        networkController = _networkController
    }
    
    func getForecast(completionHandler: @escaping ([ForecastDay]?, Error?) -> ()) {
        networkController.getForecast(completion: { (result) in
            switch result {
            case let .success(jsonDictionary):
                if let jsonForecastArray = jsonDictionary[APIDictionaryKey.Forecast] as? Array<Any> {
                    let forecasts : [Forecast?] = jsonForecastArray.map({ (eachforecast) in
                        if let forecastDictionary = eachforecast as? Dictionary<String,Any>,
                            let forecast = try? Forecast(withDictionary: forecastDictionary) {
                            return forecast
                        } else {
                            assertionFailure("INVALID FORECAST DATA")
                            return nil
                        }
                    })
                    
                    let allvalidforecasts = forecasts.flatMap{ $0 } // remove optionals
                    
                    var day = ForecastDay()
                    day.items = allvalidforecasts
                    DispatchQueue.main.async {
                        completionHandler([day],nil)
                    }
                }

            case let .error(error):
                completionHandler(nil,error)
            }
        })
    }
}
