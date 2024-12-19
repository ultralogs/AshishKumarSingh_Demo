//
//  CoreDataLayer.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func saveCoins(_ coins: [Coin])
    func fetchCoins() -> [Coin]
}

class CoreDataManager : CoreDataManagerProtocol  {
    static let shared = CoreDataManager()

    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "AshishKrSingh_Demo")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to initialize: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveCoins(_ coins: [Coin]) {
        context.perform {
            coins.forEach { coin in
                let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "symbol == %@", coin.symbol)

                do {
                    let results = try self.context.fetch(fetchRequest)
                    let entity: CoinEntity
                    if let existingEntity = results.first {
                        entity = existingEntity
                    } else {
                        entity = CoinEntity(context: self.context)
                    }

                    entity.name = coin.name
                    entity.symbol = coin.symbol
                    entity.isNew = coin.isNew
                    entity.isActive = coin.isActive
                    entity.type = coin.type
                } catch {
                    print("Failed to fetch or save coin: \(error)")
                }
            }

            do {
                try self.context.save()
            } catch {
                print("Failed to save coins: \(error)")
            }
        }
    }


    func fetchCoins() -> [Coin] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoinEntity")

        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map {
                Coin(
                    name: $0.value(forKey: "name") as! String,
                    symbol: $0.value(forKey: "symbol") as! String,
                    isNew: $0.value(forKey: "isNew") as! Bool,
                    isActive: $0.value(forKey: "isActive") as! Bool,
                    type: $0.value(forKey: "type") as! String
                )
            }
        } catch {
            print("Failed to fetch coins: \(error)")
            return []
        }
    }
}
