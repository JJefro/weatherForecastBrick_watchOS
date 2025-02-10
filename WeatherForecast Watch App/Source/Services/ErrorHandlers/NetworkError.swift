//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

enum NetworkError: Error {
    case badStatusCode
    case badURL
    case badServerResponse
    case noDataError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badStatusCode:
            return String(localized: "network_error_bad_status_code")
        case .badURL:
            return String(localized: "network_error_bad_url")
        case .badServerResponse:
            return String(localized: "network_error_bad_server_response")
        case .noDataError:
            return String(localized: "network_error_no_data")
        }
    }
}
