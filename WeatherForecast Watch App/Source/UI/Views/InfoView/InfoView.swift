//
//  InfoView.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 10/02/2025.
//

import SwiftUI

struct InfoView: View {
    let dataSource: [InfoViewItem]

    init(dataSource: [InfoViewItem] = InfoViewItemsFactory().getInfoViewItems()) {
        self.dataSource = dataSource
    }

    var body: some View {
        ScrollView(.vertical) {
            Text("info_title")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            ForEach(dataSource.indices, id: \.self) { index in
                Text(dataSource[index].text)
                    .font(.body)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .padding()
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.primary)
    }
}
