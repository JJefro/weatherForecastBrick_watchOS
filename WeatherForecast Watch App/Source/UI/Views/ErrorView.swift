//
//  ErrorView.swift
//  WeatherForecast
//
//  Created by Jevgenijs Jefrosinins on 12/02/2025.
//

import SwiftUI

struct ErrorView: View {
    var error: any Error
    var retryAction: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                Text(error.localizedDescription)
                HStack {
                    Button("Retry") {
                        retryAction()
                    }
                }
            }
            .padding()
        }
    }
}
