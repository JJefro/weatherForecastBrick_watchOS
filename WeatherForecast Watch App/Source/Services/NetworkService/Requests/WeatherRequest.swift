//
//  WeatherRequest.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

struct WeatherRequest: RequestProtocol {
    typealias Entity = WeatherEntity

    var httpMethod: String?
    var urlComponents: URLComponents? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"

        components.queryItems = [
            URLQueryItem(name: "appid", value: Secrets.apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components
    }()

    init(city: String) {
        urlComponents?.queryItems?.append(URLQueryItem(name: "q", value: city))
    }

    init(lat: Double, lon: Double) {
        urlComponents?.queryItems?.append(URLQueryItem(name: "lat", value: String(lat)))
        urlComponents?.queryItems?.append(URLQueryItem(name: "lon", value: String(lon)))
    }
}
