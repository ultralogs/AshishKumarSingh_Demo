//
//  APIServices.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCoins() async throws -> [Coin]
}

class APIService : APIServiceProtocol {
    private let networkClient: NetworkClientProtocol
    private let logger: LoggerServiceProtocol

    init(networkClient: NetworkClientProtocol, logger: LoggerServiceProtocol) {
        self.networkClient = networkClient
        self.logger = logger
    }

    func fetchCoins() async throws -> [Coin] {
        guard let url = URLBuilder.buildCoinsURL() else {
            throw URLError(.badURL)
        }
        logger.log("Fetching coins from API...")
        return try await networkClient.fetch([Coin].self, from: url)
    }
}
