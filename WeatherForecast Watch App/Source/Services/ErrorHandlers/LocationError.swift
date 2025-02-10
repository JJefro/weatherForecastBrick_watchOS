//
//  LocationError.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

enum LocationError: Error {
    case locationNotFound
    case locationServicesDisabled
    case locationServicesNotAuthorized
    case unknownStatus
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationNotFound:
            return String(localized: "location_error_location_not_found")
        case .locationServicesDisabled:
            return String(localized: "location_error_location_services_disabled")
        case .locationServicesNotAuthorized:
            return String(localized: "location_error_location_services_not_authorized")
        case .unknownStatus:
            return String(localized: "location_error_unknown_status")
        }
    }
}
