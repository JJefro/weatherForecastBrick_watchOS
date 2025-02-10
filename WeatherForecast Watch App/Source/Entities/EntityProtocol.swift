//
//  EntityProtocol.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

public protocol EntityProtocol: Codable, Equatable {
    associatedtype Model: Codable
    var id: UUID { get }

    init(data: Model)
}

public extension EntityProtocol {
    var id: UUID { UUID() }
}
