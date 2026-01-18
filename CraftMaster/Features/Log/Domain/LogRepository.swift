//
//  LogRepository.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

protocol LogRepository {
    func listLogs(goalId: UUID?) async throws -> [LogEntry]
    func upsertLog(goalId: UUID, day: Date, minutes: Int) async throws -> LogEntry
    func deleteLog(id: UUID) async throws
    func countLogs(goalId: UUID) async throws -> Int
}
