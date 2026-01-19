//
//  Persisted.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct Persisted<T: Codable>: Codable {
    let schemaVersion: Int
    let savedAt: Date
    let data: T

    init(schemaVersion: Int, data: T, savedAt: Date = Date()) {
        self.schemaVersion = schemaVersion
        self.savedAt = savedAt
        self.data = data
    }
}
