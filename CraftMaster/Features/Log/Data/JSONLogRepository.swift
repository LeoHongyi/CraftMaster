//
//  JSONLogRepository.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

actor JSONLogRepository: LogRepository {
    private let fileURL: URL
    private let currentSchema = 2

    init(filename: String = "logs.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func listLogs(goalId: UUID?) async throws -> [LogEntry] {
        let all = try loadAll()
        let filtered = goalId == nil ? all : all.filter { $0.goalId == goalId }
        return filtered.sorted { $0.day > $1.day }
    }

    private func normalizeDays(_ logs: [LogEntry]) -> [LogEntry] {
        let cal = Calendar.current
        return logs.map { entry in
            LogEntry(
                id: entry.id,
                goalId: entry.goalId,
                day: cal.startOfDay(for: entry.day),
                minutes: entry.minutes,
                createdAt: entry.createdAt,
                updatedAt: entry.updatedAt
            )
        }
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

        // 1) 先尝试 v2：Persisted<[LogEntry]>
        if let persisted = try? JSONDecoder().decode(Persisted<[LogEntry]>.self, from: data) {
            // 如果未来遇到 schemaVersion > currentSchema，可以在这里决定降级/忽略
           return normalizeDays(persisted.data)
        }

        // 2) 尝试 v1：旧格式直接是 [LogEntryV1]
        if let v1 = try? JSONDecoder().decode([LogEntryV1].self, from: data) {
            let migrated = normalizeDays(migrateFromV1(v1))
            // 写回成 v2 格式，完成升级
            try persistV2(migrated)
            return migrated
        }

        // 3) 两种都失败：说明文件损坏或未知格式
        throw AppError.unknown
    }

    private func migrateFromV1(_ v1: [LogEntryV1]) -> [LogEntry] {
       let cal = Calendar.current
       return v1.map { old in
           LogEntry(
               id: old.id,
               goalId: old.goalId,
               day: cal.startOfDay(for: old.day),
               minutes: old.minutes,
               createdAt: old.createdAt,
               updatedAt: old.createdAt
           )
       }
   }
   
   private func persist(_ logs: [LogEntry]) throws {
       try persistV2(logs)
   }

   private func persistV2(_ logs: [LogEntry]) throws {
       let wrapped = Persisted(schemaVersion: currentSchema, data: logs)
       let data = try JSONEncoder().encode(wrapped)
       try data.write(to: fileURL, options: [.atomic])
   }
   
}
