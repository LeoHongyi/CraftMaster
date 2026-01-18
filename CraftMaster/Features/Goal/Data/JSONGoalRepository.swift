//
//  JSONGoalRepository.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

actor JSONGoalRepository: GoalRepository {

    private let fileURL: URL

    init(filename: String = "goals.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func listGoals() async throws -> [Goal] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        let goals = try JSONDecoder().decode([Goal].self, from: data)
        return goals.sorted { $0.createdAt > $1.createdAt }
    }

    func createGoal(title: String, targetHours: Int) async throws -> Goal {
        var goals = try await listGoals()
        let newGoal: Goal = await MainActor.run {
            Goal(
                id: UUID(),
                title: title,
                targetHours: targetHours,
                createdAt: Date()
            )
        }
        goals.insert(newGoal, at: 0)
        try persist(goals)
        return newGoal
    }

    private func persist(_ goals: [Goal]) throws {
        let data = try JSONEncoder().encode(goals)
        try data.write(to: fileURL, options: [.atomic])
    }
}
