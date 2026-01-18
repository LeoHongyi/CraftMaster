import Foundation

actor InMemoryAchievementRepository: AchievementRepository {
    private var storage: [AchievementUnlock] = []

    func listUnlocked() async throws -> [AchievementUnlock] {
        storage
    }

    func saveUnlocked(_ unlocks: [AchievementUnlock]) async throws {
        storage = unlocks
    }

    // MARK: - Debug/Test helpers
    func _debug_seed(_ unlocks: [AchievementUnlock]) async {
        storage = unlocks
    }
}

