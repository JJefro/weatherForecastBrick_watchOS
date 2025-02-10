//
//  WeatherEntity.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

struct WeatherEntity: EntityProtocol {
    let conditionID: Int
    let visibility: Int
    let cityName: String
    let temperature: Double
    let countryCode: String
    let windSpeed: Double
    let temperatureFeelsLike: Double

    var tempString: String {
        let temp = String(format: "%.0f", temperature)
        return "\(temp)°"
    }

    var country: String? {
        let current = Locale(identifier: "en-US")
        return current.localizedString(forRegionCode: countryCode)
    }

    var condition: WeatherState {
        return .init(condition: conditionID)
    }
}

extension WeatherEntity {
    init(data: WeatherModel) {
        conditionID = data.weather[0].identifier
        visibility = data.visibility
        cityName = data.cityName
        temperature = data.main.temperature
        countryCode = data.sys.countryCode
        windSpeed = data.wind.speed
        temperatureFeelsLike = data.main.feelsLike
    }
}

enum WeatherState: String {
    case thunderstorm
    case drizzle
    case raining
    case snow
    case fog
    case tornado
    case sunny
    case clouds
    case unknown

    var localized: LocalizedStringResource {
        switch self {
        case .thunderstorm:
            return LocalizedStringResource("weather_condition_thunderstorm", defaultValue: "")
        case .drizzle:
            return LocalizedStringResource("weather_condition_drizzle", defaultValue: "")
        case .raining:
            return LocalizedStringResource("weather_condition_raining", defaultValue: "")
        case .snow:
            return LocalizedStringResource("weather_condition_snow", defaultValue: "")
        case .fog:
            return LocalizedStringResource("weather_condition_fog", defaultValue: "")
        case .tornado:
            return LocalizedStringResource("weather_condition_tornado", defaultValue: "")
        case .sunny:
            return LocalizedStringResource("weather_condition_sunny", defaultValue: "")
        case .clouds:
            return LocalizedStringResource("weather_condition_clouds", defaultValue: "")
        case .unknown:
            return LocalizedStringResource("weather_condition_unknown", defaultValue: "")
        }
    }
}

extension WeatherState {
    init(condition: Int) {
        switch condition {
        case 200...299: self = .thunderstorm
        case 300...399: self = .drizzle
        case 500...599: self = .raining
        case 600...699: self = .snow
        case 700...780: self = .fog
        case 781: self = .tornado
        case 800: self = .sunny
        case 801...899: self = .clouds
        default: self = .unknown
        }
    }
}


#if DEBUG
extension WeatherEntity {
    static var mockRain: Self {
        .init(conditionID: 500, visibility: 10_000, cityName: "London", temperature: 10, countryCode: "uk", windSpeed: 10, temperatureFeelsLike: 5)
    }

    static var mockSnow: Self {
        .init(conditionID: 600, visibility: 10_000, cityName: "Riga", temperature: -99, countryCode: "lv", windSpeed: 5, temperatureFeelsLike: -100)
    }

    static var mockWind: Self {
        .init(conditionID: 781, visibility: 5_000, cityName: "Florida", temperature: 20, countryCode: "us", windSpeed: 35, temperatureFeelsLike: 21)
    }

    static var mockThunderstorm: Self {
        .init(conditionID: 200, visibility: 5_000, cityName: "Moscow", temperature: 13, countryCode: "ru", windSpeed: 23, temperatureFeelsLike: 9)
    }

    static var mockFog: Self {
        .init(conditionID: 700, visibility: 100, cityName: "London", temperature: 8, countryCode: "uk", windSpeed: 0, temperatureFeelsLike: 4)
    }

    static var mockSunny: Self {
        .init(conditionID: 800, visibility: 20_000, cityName: "Abu Dhabi", temperature: 35, countryCode: "ae", windSpeed: 3, temperatureFeelsLike: 30)
    }
}
#endif
