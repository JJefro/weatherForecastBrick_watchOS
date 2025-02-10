//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by j.jefrosinins on 08/02/2025.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    var delegate: NetworkServiceDelegate? { get set }

    func perform<Request: RequestProtocol>(request: Request) -> AnyPublisher<Request.Entity, Error>
}

protocol NetworkServiceDelegate: AnyObject {
    func networkService(_ networkService: NetworkServiceProtocol, didFetchError entity: WeatherErrorEntity)
}

class NetworkService: NetworkServiceProtocol {
    weak var delegate: NetworkServiceDelegate?
    private var cancellables: Set<AnyCancellable> = []

    func perform<Request: RequestProtocol>(request: Request) -> AnyPublisher<Request.Entity, Error> {
        Future<Request.Entity, Error> { [weak self] promise in
            guard let self else { return }
            Task {
                switch await self.perform(request: request) {
                case let .success(entity):
                    promise(.success(entity))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    private func perform<Request: RequestProtocol>(request: Request) async -> Result<Request.Entity, Error> {
        guard let url = request.urlComponents?.url else {
            return .failure(NetworkError.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                return .failure(NetworkError.badServerResponse)
            }

            guard response.statusCode / 100 == 2 else {
                return .failure(NetworkError.badStatusCode)
            }

            if response.statusCode / 100 == 4 {
                if let error = await parseError(data) {
                    return .failure(error)
                }
            }
            return await request.decode(data)
        } catch {
            return .failure(error)
        }
    }

    private func parseError(_ data: Data) async -> WeatherErrorEntity? {
        let request = WeatherErrorRequest()
        switch await request.decode(data) {
        case let .success(errorEntity):
            return errorEntity
        default: return nil
        }
    }
}
