//
//  TextFieldView.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 10/02/2025.
//

import SwiftUI

struct SearchView: View {
    @Binding var inputText: String
    @Binding var isPresented: Bool

    var onSearchButtonTap: () -> Void

    var body: some View {
        VStack {
            Text("search_alert_title")
            TextField("search_alert_textfield_placeholder", text: $inputText)
                .padding()
            HStack {
                Button("search_alert_search_button") {
                    onSearchButtonTap()
                    isPresented.toggle()
                }
                Button("search_alert_cancel_button") {
                    isPresented.toggle()
                }
            }
        }
    }
}
