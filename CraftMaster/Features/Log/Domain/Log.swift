//
//  Log.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

struct LogEntry: Identifiable, Equatable, Hashable, Sendable, Codable {
    let id: UUID
    let goalId: UUID
    let day: Date          // 只关心“哪一天”
    var minutes: Int
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        goalId: UUID,
        day: Date,
        minutes: Int,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.goalId = goalId
        self.day = day
        self.minutes = minutes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
