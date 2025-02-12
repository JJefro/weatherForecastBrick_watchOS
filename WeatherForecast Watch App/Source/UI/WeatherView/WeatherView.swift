//
//  WeatherView.swift
//  WeatherForecast Watch App
//
//  Created by j.jefrosinins on 08/02/2025.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var presenter: WeatherPresenter
    @ObservedObject var brickPresenter: BrickPresenter

    @GestureState var dragState: DragState = .inactive

    init(
        presenter: WeatherPresenter = WeatherPresenter(),
        brickPresenter: BrickPresenter = BrickPresenter()
    ) {
        self.presenter = presenter
        self.brickPresenter = brickPresenter
    }
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            getBodyContent()
                .onAppear {
                    presenter.fetchWeatherAtCurrentLocation()
                }
        }
        .sheet(isPresented: $presenter.uiModel.showSearchView) {
            SearchView(inputText: $presenter.uiModel.searchTextFieldText,
                          isPresented: $presenter.uiModel.showSearchView) {
                presenter.fetchWeatherAtNewLocation()
            }
        }
        .sheet(isPresented: $presenter.uiModel.showInfoView) {
            InfoView()
        }
    }

    @ViewBuilder
    func getBodyContent() -> some View {
        switch presenter.uiModel.state {
        case .loading:
            LoadingView()
        case let .error(error):
            ErrorView(error: error) {
                presenter.fetchWeather()
            }
        case let .content(entity):
            GeometryReader { geometry in
                ZStack {
                    HStack {
                        buildWeatherConditionTextLabel(entity)
                            .padding(.leading)
                        Spacer()
                        Button {
                            presenter.uiModel.showInfoView.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing)
                    }
                    HStack {
                        Spacer()
                        BrickView(
                            presenter: brickPresenter,
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                        .onTapGesture(count: 3) {
                            presenter.fetchWeather()
                        }
                        .onAppear {
                            brickPresenter.updateBrickCondition(with: entity)
                        }
                        Spacer()
                    }
                }
                .overlay(alignment: .bottom) {
                    HStack {
                        buildCurrentLocationButton {
                            presenter.fetchWeatherAtCurrentLocation()
                        }
                        .padding(.leading)
                        Spacer()
                        buildLocationTextLabel(entity)
                        Spacer()
                        buildSearchButton {
                            presenter.uiModel.showSearchView.toggle()
                        }
                        .padding(.trailing)
                    }
                }
            }
        }
    }

    // MARK: - Weather Condition Text Label
    @ViewBuilder
    private func buildWeatherConditionTextLabel(_ entity: WeatherEntity) -> some View {
        VStack(alignment: .leading) {
            Text(entity.tempString)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            Text(entity.condition.localized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Current Location Button
    @ViewBuilder
    private func buildCurrentLocationButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "paperplane.fill")
                .resizable()
                .frame(width: 22, height: 22)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Location Text Label
    @ViewBuilder
    private func buildLocationTextLabel(_ entity: WeatherEntity) -> some View {
        Text("\(entity.cityName), \(entity.country ?? "")")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.center)
    }

    // MARK: - Search Button
    @ViewBuilder
    private func buildSearchButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 22, height: 22)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WeatherView()
}
