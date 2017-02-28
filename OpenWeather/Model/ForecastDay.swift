//
//  ForecastDay.swift
//  OpenWeather
//
//  Created by Daniel Broad on 26/02/2017.
//  Copyright © 2017 Dorada App Software Ltd. All rights reserved.
//

import Foundation

class ForecastDay { // class because items is mutable
    var timeStamp : Date?
    var items : [Forecast] = []
}
