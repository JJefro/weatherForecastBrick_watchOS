//
//  WeatherViewInteractor.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation
import Combine

protocol WeatherInteractorDelegate: AnyObject {
    func weatherInteractor(_ weatherInteractor: WeatherInteractorProtocol, didUpdateWeather entity: WeatherEntity)
    func weatherInteractor(_ weatherInteractor: WeatherInteractorProtocol, onErrorOccured error: Error)
    func weatherInteractor(_ weatherInteractor: WeatherInteractorProtocol, didFetchError entity: WeatherErrorEntity)
}

protocol WeatherInteractorProtocol {
    var delegate: WeatherInteractorDelegate? { get set }

    func updateWeatherAtCurrentLocation() async
    func updateWeatherAt(city: String) async
}

final class WeatherInterator: WeatherInteractorProtocol {
    weak var delegate: WeatherInteractorDelegate?
    private let locationManager: LocationManagerProtocol
    private var networkService: NetworkServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(locationManager: LocationManagerProtocol = LocationManager(), networkService: NetworkServiceProtocol = NetworkService()) {
        self.locationManager = locationManager
        self.networkService = networkService

        self.networkService.delegate = self
    }

    func updateWeatherAtCurrentLocation() async {
        do {
            let coordinate = try await locationManager.requestLocation()
            handleWeather(networkService.perform(request: WeatherRequest(lat: coordinate.lat, lon: coordinate.lon)))
        } catch {
            self.delegate?.weatherInteractor(self, onErrorOccured: error)
        }
    }

    func updateWeatherAt(city: String) async {
        handleWeather(networkService.perform(request: WeatherRequest(city: city)))
    }

    private func handleWeather(_ result: AnyPublisher<WeatherEntity, Error>) {
        result
            .sink { [weak self] completion in
                guard let self else { return }
                if case let .failure(error) = completion {
                    self.delegate?.weatherInteractor(self, onErrorOccured: error)
                }
            } receiveValue: { [weak self] entity in
                guard let self else { return }
                self.delegate?.weatherInteractor(self, didUpdateWeather: entity)
            }
            .store(in: &cancellables)
    }
}

extension WeatherInterator: NetworkServiceDelegate {
    func networkService(_ networkService: any NetworkServiceProtocol, didFetchError entity: WeatherErrorEntity) {
        delegate?.weatherInteractor(self, didFetchError: entity)
    }
}
