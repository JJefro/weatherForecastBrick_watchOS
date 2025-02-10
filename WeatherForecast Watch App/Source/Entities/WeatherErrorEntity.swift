//
//  WeatherErrorEntity.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

struct WeatherErrorEntity: EntityProtocol, Error {
    let cod: String
    let message: String

    init(data: WeatherErrorModel) {
        cod = data.cod
        message = data.message
    }
}

extension WeatherErrorEntity: LocalizedError {
    var errorDescription: String? { message }
}
