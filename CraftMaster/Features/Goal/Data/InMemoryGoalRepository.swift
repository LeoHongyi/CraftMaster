import Foundation

actor InMemoryGoalRepository: GoalRepository {
    private var storage: [Goal] = [
        Goal(title: "Learn iOS", targetHours: 300, createdAt: Date()),
        Goal(title: "Build CraftMaster", targetHours: 200, createdAt: Date())
    ]

    func listGoals() async throws -> [Goal] {
        return storage.sorted { $0.createdAt > $1.createdAt }
    }

    func createGoal(title: String, targetHours: Int) async throws -> Goal {
        let new = Goal(title: title, targetHours: targetHours, createdAt: Date())
        storage.insert(new, at: 0)
        return new
    }

    func updateGoal(_ goal: Goal) async throws {
        guard let idx = storage.firstIndex(where: { $0.id == goal.id }) else { return }
        storage[idx] = goal
    }

    func deleteGoal(id: UUID) async throws {
        // Soft delete: archive only (keep logs intact).
        guard let idx = storage.firstIndex(where: { $0.id == id }) else { return }
        var g = storage[idx]
        g.isArchived = true
        storage[idx] = g
    }
}
