//
//  LocationCoordinate.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation
import CoreLocation

struct LocationCoordinate {
    let lat: Double
    let lon: Double
}

extension LocationCoordinate {
    init(coordinate: CLLocationCoordinate2D) {
        self.init(lat: coordinate.latitude, lon: coordinate.longitude)
    }
}
