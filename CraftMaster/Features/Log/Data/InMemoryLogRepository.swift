import Foundation

actor InMemoryLogRepository: LogRepository {
    private var storage: [LogEntry] = []

    func listLogs(goalId: UUID?) async throws -> [LogEntry] {
        let filtered = goalId == nil ? storage : storage.filter { $0.goalId == goalId }
        return filtered.sorted { $0.day > $1.day }
    }

    func upsertLog(goalId: UUID, day: Date, minutes: Int) async throws -> LogEntry {
        let normalizedDay = Calendar.current.startOfDay(for: day)

        if let idx = storage.firstIndex(where: {
            $0.goalId == goalId && Calendar.current.isDate($0.day, inSameDayAs: normalizedDay)
        }) {
            var existing = storage[idx]
            existing.minutes = minutes
            existing.updatedAt = Date()
            storage[idx] = existing
            return existing
        }

        let new = LogEntry(goalId: goalId, day: normalizedDay, minutes: minutes)
        storage.append(new)
        return new
    }

    func deleteLog(id: UUID) async throws {
        storage.removeAll { $0.id == id }
    }

    func countLogs(goalId: UUID) async throws -> Int {
        storage.filter { $0.goalId == goalId }.count
    }

    // MARK: - Debug helpers (used by tests)
    func _debug_seed(_ logs: [LogEntry]) async {
        storage = logs
    }
}

