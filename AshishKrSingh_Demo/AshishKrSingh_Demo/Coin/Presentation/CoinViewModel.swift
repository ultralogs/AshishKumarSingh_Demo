//
//  CoinViewModel.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation
import Combine

class CoinViewModel {
    
    // MARK: - Properties
    
    private let fetchCoinsUseCase: FetchCoinsUseCase
    private var allCoins: [Coin] = []
    var filteredCoins: [Coin] = []
    
    var onCoinsUpdated: (([Coin]) -> Void)?
    
    // MARK: - Initialization
    
    init(fetchCoinsUseCase: FetchCoinsUseCase) {
        self.fetchCoinsUseCase = fetchCoinsUseCase
    }
    
    // MARK: - Data Loading
    func fetchCoins() {
        Task {
            do {
                let coins = try await fetchCoinsUseCase.execute().sorted {
                    let name1 = $0.name
                    let name2 = $1.name
                    return name1 < name2
                }
                allCoins = coins
                filteredCoins = coins
                notifyUpdate()
            } catch {
                print("Error fetching coins: \(error)")
            }
        }
    }
        
    func filterCoins(withFilters selectedFilters: [FilterView.FilterViewOptions], searchText: String) {
        filteredCoins = allCoins.filter { coin in
            var matchesAllFilters = true

            for filter in selectedFilters {
                switch filter {
                case .active:
                    if !coin.isActive {
                        matchesAllFilters = false
                    }
                case .inactive:
                    if coin.isActive {
                        matchesAllFilters = false
                    }
                case .onlyTokens:
                    if coin.type.lowercased() == "coin" {
                        matchesAllFilters = false
                    }
                case .onlyCoins:
                    if coin.type.lowercased() != "coin" {
                        matchesAllFilters = false
                    }
                case .newCoins:
                    if !coin.isNew {
                        matchesAllFilters = false
                    }
                }
            }
            
            return matchesAllFilters
        }
        
        if !searchText.isEmpty {
            filteredCoins = filteredCoins.filter { coin in
                coin.name.lowercased().contains(searchText.lowercased()) ||
                coin.symbol.lowercased().contains(searchText.lowercased())
            }
        }
        notifyUpdate()
    }

    // MARK: - Helpers
    
    private func notifyUpdate() {
        onCoinsUpdated?(filteredCoins)
    }
}
