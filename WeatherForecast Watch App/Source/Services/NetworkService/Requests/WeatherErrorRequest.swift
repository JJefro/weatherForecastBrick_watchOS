//
//  WeatherErrorRequest.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

struct WeatherErrorRequest: RequestProtocol {
    typealias Entity = WeatherErrorEntity

    var httpMethod: String?
    var urlComponents: URLComponents?
}
