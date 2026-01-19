import Foundation

actor InMemoryGoalRepository: GoalRepository {
    private var storage: [Goal] = [
        Goal(title: "Learn iOS", targetHours: 300, createdAt: Date(), isArchived: false),
        Goal(title: "Build CraftMaster", targetHours: 200, createdAt: Date(), isArchived: false)
    ]

    /// Day3: 临时模拟 “某些 goal 有记录”
    private var logCountByGoalId: [UUID: Int] = [:]

    func listGoals() async throws -> [Goal] {
        storage.sorted { $0.createdAt > $1.createdAt }
    }

    func createGoal(title: String, targetHours: Int) async throws -> Goal {
        let new = Goal(title: title, targetHours: targetHours, createdAt: Date(), isArchived: false)
        storage.insert(new, at: 0)
        // 默认没有记录
        logCountByGoalId[new.id] = 0
        return new
    }

    func updateGoal(_ goal: Goal) async throws {
        guard let idx = storage.firstIndex(where: { $0.id == goal.id }) else { return }
        storage[idx] = goal
    }

    func deleteGoal(id: UUID) async throws {
        // Soft delete: archive only. Keep logs and other data intact.
        guard let idx = storage.firstIndex(where: { $0.id == id }) else { return }
        var archived = storage[idx]
        archived.isArchived = true
        storage[idx] = archived
    }

    func logCount(goalId: UUID) async throws -> Int {
        logCountByGoalId[goalId, default: 0]
    }

    // 仅用于你本地调试：给某个 goal 加上“已有记录”
    func _debug_setLogCount(goalId: UUID, count: Int) async {
        logCountByGoalId[goalId] = count
    }
}
