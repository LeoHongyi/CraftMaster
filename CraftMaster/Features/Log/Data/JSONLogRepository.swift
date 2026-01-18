//
//  JSONLogRepository.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

actor JSONLogRepository: LogRepository {
    private let fileURL: URL

    init(filename: String = "logs.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func listLogs(goalId: UUID?) async throws -> [LogEntry] {
        let all = try loadAll()
        let filtered = goalId == nil ? all : all.filter { $0.goalId == goalId }
        return filtered.sorted { $0.day > $1.day }
    }

    func upsertLog(goalId: UUID, day: Date, minutes: Int) async throws -> LogEntry {
        var logs = try loadAll()
        let normalizedDay = Calendar.current.startOfDay(for: day)

        if let idx = logs.firstIndex(where: { $0.goalId == goalId && Calendar.current.isDate($0.day, inSameDayAs: normalizedDay) }) {
            var existing = logs[idx]
            existing.minutes = minutes
            existing.updatedAt = Date()
            logs[idx] = existing
            try persist(logs)
            return existing
        } else {
            let new = LogEntry(goalId: goalId, day: normalizedDay, minutes: minutes)
            logs.append(new)
            try persist(logs)
            return new
        }
    }

    func deleteLog(id: UUID) async throws {
        var logs = try loadAll()
        logs.removeAll { $0.id == id }
        try persist(logs)
    }

    func countLogs(goalId: UUID) async throws -> Int {
        let logs = try loadAll()
        return logs.filter { $0.goalId == goalId }.count
    }

    // MARK: - persistence
    private func loadAll() throws -> [LogEntry] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([LogEntry].self, from: data)
    }

    private func persist(_ logs: [LogEntry]) throws {
        let data = try JSONEncoder().encode(logs)
        try data.write(to: fileURL, options: [.atomic])
    }
}
