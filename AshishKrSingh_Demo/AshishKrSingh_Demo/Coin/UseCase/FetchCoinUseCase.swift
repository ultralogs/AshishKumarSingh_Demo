//
//  FetchCoinUserCase.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation

class FetchCoinsUseCase {
    private let repository: CoinRepository

    init(repository: CoinRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Coin] {
        return try await repository.execute()
    }
}
