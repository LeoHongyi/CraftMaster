//
//  AppError.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case unknown
    case invalidInput(String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .invalidInput(let msg):
            return msg
        }
    }
}
