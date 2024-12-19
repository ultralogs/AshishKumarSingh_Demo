//
//  LoggerServices.swift
//  AshishKrSingh_Demo
//
//  Created by Ashish Kumar Singh on 18/12/24.
//

import Foundation

protocol LoggerServiceProtocol {
    func log(_ message: String)
}

class LoggerService: LoggerServiceProtocol {
    func log(_ message: String) {
        print("[LOG]: \(message)")
    }
}
