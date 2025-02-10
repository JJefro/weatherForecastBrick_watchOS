//
//  WeatherPresenter.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import SwiftUI

final class WeatherPresenter: ObservableObject {
    var interactor: WeatherInteractorProtocol
    @Published var uiModel: WeatherUIModel

    init(interactor: WeatherInteractorProtocol = WeatherInterator(),
         uiModel: WeatherUIModel = .init(state: .content(.mockWind))) {
        self.interactor = interactor
        self.uiModel = uiModel

        self.interactor.delegate = self
    }

    func fetchWeatherAtCurrentLocation() {
        uiModel.state = .loading
        Task {
            await interactor.updateWeatherAtCurrentLocation()
        }
    }

    func fetchWeatherAtNewLocation() {
        uiModel.state = .loading
        if !uiModel.searchTextFieldText.isEmpty {
            let text = NSMutableString(string: uiModel.searchTextFieldText) as CFMutableString
            CFStringTransform(text, nil, kCFStringTransformStripCombiningMarks, false)
            var city = (text as NSMutableString).copy() as! NSString
            city = city.replacingOccurrences(of: " ", with: "%20") as NSString
            Task {
                await interactor.updateWeatherAt(city: String(city))
            }
        } else {
            fetchWeather()
        }
        uiModel.searchTextFieldText = ""
    }

    func fetchWeather() {
        uiModel.state = .loading
        if let city = uiModel.currentCity {
            Task {
                await interactor.updateWeatherAt(city: city)
            }
        } else {
            fetchWeatherAtCurrentLocation()
        }
    }
}

extension WeatherPresenter: WeatherInteractorDelegate {
    func weatherInteractor(_ weatherInteractor: WeatherInteractorProtocol, didUpdateWeather entity: WeatherEntity) {
        uiModel.state = .content(entity)
        uiModel.currentCity = entity.cityName
    }

    func weatherInteractor(_ weatherInteractor: WeatherInteractorProtocol, onErrorOccured error: any Error) {
        uiModel.state = .error(error)
    }

    func weatherInteractor(_ weatherInteractor: WeatherInteractorProtocol, didFetchError entity: WeatherErrorEntity) {
        uiModel.state = .error(entity)
    }
}
