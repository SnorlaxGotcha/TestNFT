//
//  APIRepository.swift
//  TestOpenseaapi
//
//  Created by 黃世維 on 2022/4/19.
//

import Foundation
import Combine

enum NetworkError: Error {
    case request(underlyingError: Error)
    case unableToDecode(underlyingError: Error)
    case unableToRequest(underlyingError: Error)
}

protocol APIRepository {
    func getAssests(cursor: String, offset: Int, limit: Int) async throws -> AnyPublisher<MyAssets, NetworkError>
}

struct OpenseaApi {
    private func makeRequest() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        
        var headers: [AnyHashable : Any] = [:]
        headers["Accept"] = "application/json"
        headers["X-Api-Key"] = "5b294e9193d240e39eefc5e6e551ce83"

        config.httpAdditionalHeaders = headers
        return config
    }
}

extension OpenseaApi: APIRepository {
    func getAssests(cursor: String, offset: Int, limit: Int) async throws -> AnyPublisher<MyAssets, NetworkError> {
        let decoder = JSONDecoder()
        let config = makeRequest()
        let session = URLSession(configuration: config)
        
        print("Current offset is \(offset)")
        print("Current cursor is \(cursor)")
        
        guard let url = URL(string: "https://api.opensea.io/api/v1/assets?order_direction=desc&offset=\(offset)&limit=\(limit)&owner=0x960DE9907A2e2f5363646d48D7FB675Cd2892e91") else {
            return Fail(error: NetworkError.unableToRequest(underlyingError: URLError(.badURL)))
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
          .retry(1)
          .mapError { NetworkError.request(underlyingError: $0) }
          .map(\.data)
          .flatMap {
            Just($0)
              .decode(type: MyAssets.self, decoder: decoder)
              .mapError { NetworkError.unableToDecode(underlyingError: $0) }
          }.eraseToAnyPublisher()
    }
}
