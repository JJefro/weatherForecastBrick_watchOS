//
//  BrickView.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 09/02/2025.
//

import SwiftUI

struct BrickView: View {
    @ObservedObject var presenter: BrickPresenter
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        presenter.uiModel.image
            .resizable()
            .frame(width: width / 1.4, height: height / 1.4)
            .aspectRatio(1, contentMode: .fit)
            .opacity(presenter.uiModel.opacity)
            .zIndex(presenter.uiModel.zPosition)
            .rotationEffect(presenter.uiModel.rotationDirection == .backward ? .degrees(presenter.uiModel.swingForce) : .degrees(-presenter.uiModel.swingForce), anchor: .top)
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                       value: presenter.uiModel.rotationDirection)
    }
}
