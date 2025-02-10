//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

struct WeatherModel: Codable {
    let cityName: String
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let sys: Sys

    struct Weather: Codable {
        let identifier: Int

        private enum CodingKeys: String, CodingKey {
            case identifier = "id"
        }
    }

    struct Wind: Codable {
        let speed: Double
    }

    struct Main: Codable {
        let temperature: Double
        let feelsLike: Double

        private enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feelsLike"
        }
    }

    struct Sys: Codable {
        let countryCode: String

        private enum CodingKeys: String, CodingKey {
            case countryCode = "country"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case weather, main, visibility, wind, sys
    }
}
