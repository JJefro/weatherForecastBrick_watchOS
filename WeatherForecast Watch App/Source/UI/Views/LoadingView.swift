//
//  LoadingView.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 09/02/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.clear)
                .ignoresSafeArea()
            ProgressView()
        }
        .background(.ultraThinMaterial)
    }
}
