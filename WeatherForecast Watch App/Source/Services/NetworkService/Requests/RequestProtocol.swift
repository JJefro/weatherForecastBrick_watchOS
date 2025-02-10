//
//  RequestProtocol.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation

protocol RequestProtocol {
    associatedtype Entity: EntityProtocol
    
    var httpMethod: String? { get }
    var urlComponents: URLComponents? { get set }
}

extension RequestProtocol {
    func decode(_ data: Data) async -> Result<Entity, Error> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decoderData = try decoder.decode(Entity.Model.self, from: data)
            return .success(Entity(data: decoderData))
        } catch {
            return .failure(error)
        }
    }
}
