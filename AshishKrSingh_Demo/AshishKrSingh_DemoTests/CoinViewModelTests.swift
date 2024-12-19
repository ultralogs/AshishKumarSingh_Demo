//
//  CoinViewModelTests.swift
//  AshishKrSingh_DemoTests
//
//  Created by Ashish Kumar Singh on 19/12/24.
//

import XCTest
@testable import AshishKrSingh_Demo

// MARK: - Mock FetchCoinsUseCase
class MockFetchCoinsUseCase: FetchCoinsUseCase {
    var shouldThrowError = false
    var coinsToReturn: [Coin] = []

    override func execute() async throws -> [Coin] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return coinsToReturn
    }
}

class CoinViewModelTests: XCTestCase {

    var viewModel: CoinViewModel!
    var mockFetchCoinsUseCase: MockFetchCoinsUseCase = MockFetchCoinsUseCase(repository: .init(apiService: APIService(networkClient: NetworkClient(), logger: LoggerService()), coreDataManager: CoreDataManager.shared))

    var isExecutionStarted : Bool = false
    
    override func setUp() {
        super.setUp()
        viewModel = CoinViewModel(fetchCoinsUseCase: mockFetchCoinsUseCase)
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test Initialization
    func testInitialization() {
        XCTAssertNotNil(viewModel)
    }

    // MARK: - Test fetchCoins Success
    func testFetchCoinsSuccess() async {
        isExecutionStarted = true
        viewModel = CoinViewModel(fetchCoinsUseCase: mockFetchCoinsUseCase)
        let expectedCoins = [
            Coin(name: "Bitcoin", symbol: "BTC",isNew: false, isActive: true, type: "coin"),
            Coin(name: "Ethereum", symbol: "ETH",isNew: false, isActive: true, type: "token")
        ]
        mockFetchCoinsUseCase.coinsToReturn = expectedCoins

        viewModel.onCoinsUpdated = { coins in
            if self.isExecutionStarted {
                self.isExecutionStarted = false
                return
            }
            XCTAssertEqual(coins, expectedCoins.sorted { $0.name < $1.name })
        }
        viewModel.fetchCoins()
    }

    // MARK: - Test fetchCoins Error
    func testFetchCoinsError() async {
        
        viewModel = CoinViewModel(fetchCoinsUseCase: mockFetchCoinsUseCase)

        mockFetchCoinsUseCase.shouldThrowError = true

        viewModel.fetchCoins()
        XCTAssertTrue(viewModel.onCoinsUpdated == nil)
    }

    // MARK: - Test filterCoins Active Filter
    func testFilterCoinsActiveFilter() {
        isExecutionStarted = true
        viewModel = CoinViewModel(fetchCoinsUseCase: mockFetchCoinsUseCase)
        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC",isNew: false, isActive: true, type: "coin"),
            Coin(name: "InactiveCoin", symbol: "IC",isNew: false, isActive: false, type: "coin")
        ]
        mockFetchCoinsUseCase.coinsToReturn = coins
        viewModel.onCoinsUpdated = { coins in
            if self.isExecutionStarted {
                self.isExecutionStarted = false
                return
            }

            self.viewModel.filterCoins(withFilters: [.active], searchText: "")
            XCTAssertEqual(self.viewModel.filteredCoins.count, 1)
            XCTAssertEqual(self.viewModel.filteredCoins.first?.name, "Bitcoin")
        }
        viewModel.fetchCoins()
    }

    // MARK: - Test filterCoins Inactive Filter
    func testFilterCoinsInactiveFilter() {
        isExecutionStarted = true
        viewModel = CoinViewModel(fetchCoinsUseCase: mockFetchCoinsUseCase)
        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC",isNew: false, isActive: true, type: "coin"),
            Coin(name: "InactiveCoin", symbol: "IC",isNew: false, isActive: false, type: "coin")
        ]
        mockFetchCoinsUseCase.coinsToReturn = coins
        viewModel.onCoinsUpdated = { coins in
            if self.isExecutionStarted {
                self.isExecutionStarted = false
                return
            }

            self.viewModel.filterCoins(withFilters: [.inactive], searchText: "")
            XCTAssertEqual(self.viewModel.filteredCoins.count, 1)
            XCTAssertEqual(self.viewModel.filteredCoins.first?.name, "InactiveCoin")
        }

        viewModel.fetchCoins()
    }

    // MARK: - Test filterCoins Search Text
    func testFilterCoinsSearchText() {
        isExecutionStarted = true
        viewModel = CoinViewModel(fetchCoinsUseCase: mockFetchCoinsUseCase)
        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC",isNew: false, isActive: true, type: "coin"),
            Coin(name: "Ethereum", symbol: "ETH",isNew: false, isActive: true, type: "token")
        ]
        mockFetchCoinsUseCase.coinsToReturn = coins
        viewModel.onCoinsUpdated = { coins in
            if self.isExecutionStarted {
                self.isExecutionStarted = false
                return
            }

            self.viewModel.filterCoins(withFilters: [], searchText: "bit")
            XCTAssertEqual(self.viewModel.filteredCoins.count, 1)
            XCTAssertEqual(self.viewModel.filteredCoins.first?.name, "Bitcoin")
        }

        viewModel.fetchCoins()
    }

    // MARK: - Test filterCoins Combined Filters
    func testFilterCoinsCombinedFilters() {
        isExecutionStarted = true
        viewModel = CoinViewModel(fetchCoinsUseCase: mockFetchCoinsUseCase)
        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC",isNew: false, isActive: true, type: "coin"),
            Coin(name: "NewToken", symbol: "NT",isNew: true, isActive: true, type: "token")
        ]
        mockFetchCoinsUseCase.coinsToReturn = coins
        viewModel.onCoinsUpdated = { coins in
            if self.isExecutionStarted {
                self.isExecutionStarted = false
                return
            }

            self.viewModel.filterCoins(withFilters: [.onlyTokens, .newCoins], searchText: "")
            XCTAssertEqual(self.viewModel.filteredCoins.count, 1)
            XCTAssertEqual(self.viewModel.filteredCoins.first?.name, "NewToken")
        }
        viewModel.fetchCoins()
    }
}
