import Foundation

actor InMemoryGoalRepository: GoalRepository {
    private var storage: [Goal] = []
    private var didSeed = false

    private func seedIfNeeded() async {
        guard !didSeed else { return }
        didSeed = true

        // Swift 6 can enforce stricter global-actor isolation on initializers.
        // Seeding asynchronously lets us safely hop to MainActor if required.
        let seededGoals: [Goal] = await MainActor.run {
            [
                Goal(title: "Learn iOS", targetHours: 300, createdAt: Date()),
                Goal(title: "Build CraftMaster", targetHours: 200, createdAt: Date())
            ]
        }
        storage = seededGoals
    }

    func listGoals() async throws -> [Goal] {
        await seedIfNeeded()
        return storage.sorted { $0.createdAt > $1.createdAt }
    }

    func createGoal(title: String, targetHours: Int) async throws -> Goal {
        await seedIfNeeded()
        let new: Goal = await MainActor.run {
            Goal(title: title, targetHours: targetHours, createdAt: Date())
        }
        storage.insert(new, at: 0)
        return new
    }
}
