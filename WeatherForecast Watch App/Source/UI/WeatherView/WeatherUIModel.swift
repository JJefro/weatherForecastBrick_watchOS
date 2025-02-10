//
//  WeatherViewUIModel.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import SwiftUI

struct WeatherUIModel {
    var state: WeatherViewState

    var currentCity: String?
    var showInfoView: Bool = false
    var showSearchView: Bool = false
    var searchTextFieldText: String = ""
}

enum WeatherViewState {
    case loading
    case error(_ error: Error)
    case content(_ entity: WeatherEntity)
}
