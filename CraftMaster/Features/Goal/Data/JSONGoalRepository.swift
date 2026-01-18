//
//  JSONGoalRepository.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

actor JSONGoalRepository: GoalRepository {
    private let fileURL: URL
    private var logCountByGoalId: [UUID: Int] = [:]   // Day3 临时

    init(filename: String = "goals.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func listGoals() async throws -> [Goal] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        let goals = try JSONDecoder().decode([Goal].self, from: data)
        return goals.sorted { $0.createdAt > $1.createdAt }
    }

    func createGoal(title: String, targetHours: Int) async throws -> Goal {
        var goals = try await listGoals()
        let new = Goal(title: title, targetHours: targetHours, createdAt: Date())
        goals.insert(new, at: 0)
        try persist(goals)
        logCountByGoalId[new.id] = 0
        return new
    }

    func updateGoal(_ goal: Goal) async throws {
        var goals = try await listGoals()
        guard let idx = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[idx] = goal
        try persist(goals)
    }

    func deleteGoal(id: UUID) async throws {
        var goals = try await listGoals()
        goals.removeAll { $0.id == id }
        try persist(goals)
        logCountByGoalId[id] = nil
    }

    func logCount(goalId: UUID) async throws -> Int {
        logCountByGoalId[goalId, default: 0]
    }

    private func persist(_ goals: [Goal]) throws {
        let data = try JSONEncoder().encode(goals)
        try data.write(to: fileURL, options: [.atomic])
    }
}
