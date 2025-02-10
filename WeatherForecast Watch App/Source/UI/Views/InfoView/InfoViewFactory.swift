//
//  InfoViewFactory.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 10/02/2025.
//

struct InfoViewFactory {
    func getInfoViewItems() -> [InfoViewItem] {
        [
            InfoViewItem(text: "info_fog_label"),
            InfoViewItem(text: "info_hot_label"),
            InfoViewItem(text: "info_rain_label"),
            InfoViewItem(text: "info_snow_label"),
            InfoViewItem(text: "info_sun_label"),
            InfoViewItem(text: "info_wind_label"),
            InfoViewItem(text: "info_noInternet_label")
        ]
    }
}
