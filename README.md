# Overview of Classes and Protocols

### `CoinRepository`
The `CoinRepository` class acts as an abstraction layer between the API service and Core Data. It fetches coin data from an external API and stores it locally in Core Data. If the network request fails, it falls back to the locally stored data.

#### Methods:
- **`execute()`**: Asynchronously fetches coins from the API and saves them to Core Data. If fetching fails, it retrieves coins from Core Data.

---

### `FetchCoinsUseCase`
The `FetchCoinsUseCase` class acts as a use case in the domain layer. It interacts with the `CoinRepository` to fetch the coin data, providing an abstraction to external components.

#### Methods:
- **`execute()`**: Asynchronously invokes the repository’s `execute()` method to fetch the coins.

---

### `NetworkClientProtocol`
This protocol defines the required methods for fetching data from the network. It uses generics to handle different types of API responses.

#### Methods:
- **`fetch(_:from:)`**: Asynchronously fetches data from a given URL and decodes it into the specified type.

---

### `NetworkClient`
The `NetworkClient` class conforms to the `NetworkClientProtocol` and implements the network-fetching logic using `URLSession`. It performs a network request and decodes the response into the desired model.

#### Methods:
- **`fetch(_:from:)`**: Fetches data from the network and decodes the response into the specified type.

---

### `CoreDataManager`
The `CoreDataManager` class handles Core Data operations for storing and retrieving coin data. It uses an `NSPersistentContainer` to manage the context and persist data.

#### Methods:
- **`saveCoins(_:)`**: Saves a list of coins into Core Data.
- **`fetchCoins()`**: Fetches stored coin data from Core Data and returns it as a list of `Coin` objects.

---

### `APIServiceProtocol`
This protocol defines the interface for the service responsible for fetching coins from an external API.

#### Methods:
- **`fetchCoins()`**: Asynchronously fetches a list of coins from the API.

---

### `APIService`
The `APIService` class implements the `APIServiceProtocol` and handles the logic for making a network request to fetch coin data. It uses a `NetworkClient` for fetching data and a `LoggerService` for logging.

#### Methods:
- **`fetchCoins()`**: Fetches coin data from the API.

---

### `LoggerServiceProtocol`
This protocol defines the logging interface for logging messages in the app.

#### Methods:
- **`log(_:)`**: Logs a message.

---

### `LoggerService`
The `LoggerService` class implements `LoggerServiceProtocol` and handles logging messages to the console.

#### Methods:
- **`log(_:)`**: Logs a message to the console.

---
