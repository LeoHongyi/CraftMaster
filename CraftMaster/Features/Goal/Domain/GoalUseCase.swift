//
//  GoalUseCase.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

struct GoalUseCase {
    let repo: GoalRepository

    func list() async throws -> [Goal] {
        try await repo.listGoals()
    }

    func create(title: String, targetHours: Int = 10_000) async throws -> Goal {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw AppError.invalidInput("Title cannot be empty")
        }
        return try await repo.createGoal(title: trimmed, targetHours: targetHours)
    }
}
