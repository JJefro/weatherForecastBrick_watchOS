//
//  InfoView.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 10/02/2025.
//

import SwiftUI

struct InfoView: View {
    let dataSource: [InfoViewItem]

    init(dataSource: [InfoViewItem] = InfoViewFactory().getInfoViewItems()) {
        self.dataSource = dataSource
    }

    var body: some View {
        ScrollView(.vertical) {
            ForEach(dataSource.indices, id: \.self) { index in
                Text(dataSource[index].text)
                    .font(.body)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .padding()
            }
        }
    }
}
