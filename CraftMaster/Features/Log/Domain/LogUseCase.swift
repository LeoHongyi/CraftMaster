//
//  LogUseCase.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation



struct LogUseCase {
    let repo: LogRepository

    func upsert(goalId: UUID, day: Date, minutes: Int) async throws -> LogEntry {
        guard minutes > 0 else { throw AppError.invalidInput("Minutes must be > 0") }
        return try await repo.upsertLog(goalId: goalId, day: day, minutes: minutes)
    }

    func count(goalId: UUID) async throws -> Int {
        try await repo.countLogs(goalId: goalId)
    }
}
