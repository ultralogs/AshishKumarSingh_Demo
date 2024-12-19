//
//  Coin.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation

struct Coin: Codable, Equatable {
    let name: String
    let symbol: String
    let isNew: Bool
    let isActive: Bool
    let type: String

    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}
