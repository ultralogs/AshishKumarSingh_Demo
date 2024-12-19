//
//  CoinRepository.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation

class CoinRepository {
    
    private let apiService: APIServiceProtocol
    private let coreDataManager: CoreDataManagerProtocol
    
    init(apiService: APIServiceProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }

    func execute() async throws -> [Coin] {
        do {
            let coins = try await apiService.fetchCoins()
            self.coreDataManager.saveCoins(coins)
            return coins
        } catch {
            return self.coreDataManager.fetchCoins()
        }
    }

    
}
