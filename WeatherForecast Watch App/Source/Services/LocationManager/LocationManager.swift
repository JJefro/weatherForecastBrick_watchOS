//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import UIKit
import CoreLocation

typealias CompletionHandler = (Result<LocationCoordinate, Error>) -> Void

protocol LocationManagerProtocol {
    func requestLocation() async throws -> LocationCoordinate
}

class LocationManager: NSObject, LocationManagerProtocol {

    private let locationManager = CLLocationManager()
    private var shouldIgnoreAuthorizationChange = false
    private var continuation: CheckedContinuation<LocationCoordinate, Error>?

    override init() {
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() async throws -> LocationCoordinate {
        guard  CLLocationManager.locationServicesEnabled() else {
            throw LocationError.locationServicesDisabled
        }
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            self.continuation = continuation
            self.requestAuthorizationIfNeeded()
        }
    }

    private func requestAuthorizationIfNeeded() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            continuation?.resume(throwing: LocationError.locationServicesNotAuthorized)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default: continuation?.resume(throwing: LocationError.unknownStatus)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last, let continuation = continuation {
            continuation.resume(returning: LocationCoordinate(coordinate: location.coordinate))
            self.continuation = nil
        } else {
            continuation?.resume(throwing: LocationError.locationNotFound)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let _ = continuation else { return }
        requestAuthorizationIfNeeded()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
