//
//  BrickPresenter.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 09/02/2025.
//

import SwiftUI

struct BrickUIModel {
    var state: BrickState

    var imageName: BrickImageName = .brick
    var image: Image = Image(BrickImageName.brick.rawValue)
    var rotationDirection: RotationDirection = .forward
    var zPosition: Double = 1
    var opacity: Double = 1
    var swingForce: CGFloat = 0
}

enum BrickState {
    case brickWentUp
    case brickAnimatable
    case brickCalmedDown
}

enum BrickImageName: String {
    case brick
    case cracksBrick
    case wetBrick
    case snowyBrick
}

enum RotationDirection {
    case forward, backward
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case let .dragging(translation):
            return translation
        }
    }

    var isActive: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

final class BrickPresenter: ObservableObject {
    @Published var uiModel: BrickUIModel = .init(state: .brickCalmedDown)

    func updateBrickCondition(with weather: WeatherEntity) {
        uiModel.opacity = 1
        uiModel.zPosition = weather.condition != .fog ? 1 : -1
        uiModel.imageName = .brick

        if weather.condition == .sunny, weather.temperature > 29  {
            uiModel.imageName = .cracksBrick
        } else {
            switch weather.condition {
            case .thunderstorm: uiModel.imageName = .wetBrick
            case .drizzle: uiModel.imageName = .wetBrick
            case .raining: uiModel.imageName = .wetBrick
            case .snow: uiModel.imageName = .snowyBrick
            case .fog: updateOpacity(weather.visibility)
            case .tornado: uiModel.imageName = .brick
            case .sunny: uiModel.imageName = .brick
            case .clouds: uiModel.imageName = .brick
            case .unknown: uiModel.imageName = .brick
            }
        }
        withAnimation(.smooth(duration: 1)) { [weak self] in
            guard let self else { return }
            self.uiModel.image = Image(self.uiModel.imageName.rawValue)
        } completion: {
            withAnimation(.smooth(duration: 1)) { [weak self] in
                self?.swingIfNeeded(with: weather.windSpeed)
            }
        }
    }

    private func updateOpacity(_ weatherVisibility: Int) {
        switch weatherVisibility {
        case 20_000...: uiModel.opacity = 1
        case 10_000...19_999: uiModel.opacity = 0.9
        case 4_000...9_999: uiModel.opacity = 0.7
        case 2_000...3_999: uiModel.opacity = 0.6
        case 1_000...1_999: uiModel.opacity = 0.4
        case 500...999: uiModel.opacity = 0.3
        case 200...499: uiModel.opacity = 0.2
        case ...199: uiModel.opacity = 0.1
        default: uiModel.opacity = 0.05
        }
    }

    private func swingIfNeeded(with windForce: Double) {
        uiModel.state = .brickCalmedDown
        switch windForce {
        case 30...: uiModel.swingForce = 50
        case 21...29: uiModel.swingForce = 30
        case 15...20: uiModel.swingForce = 20
        case 11...14: uiModel.swingForce = 10
        case 6...10: uiModel.swingForce = 5
        case 1...5: uiModel.swingForce = 2
        default: uiModel.state = .brickCalmedDown
        }

        guard uiModel.swingForce > 0 else { return }
        uiModel.state = .brickAnimatable
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) { [weak self] in
            guard let self else { return }
            switch self.uiModel.rotationDirection {
            case .forward:
                self.uiModel.rotationDirection = .backward
            case .backward:
                self.uiModel.rotationDirection = .forward
            }
        }
    }
}
