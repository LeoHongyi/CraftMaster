//
//  GoalUseCase.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

import Foundation

struct GoalUseCase {
    let repo: GoalRepository
    let logRepo: LogRepository   // ✅ 新增

    func list() async throws -> [Goal] { try await repo.listGoals() }

    func create(title: String, targetHours: Int = 10_000) async throws -> Goal {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw AppError.invalidInput("Title cannot be empty") }
        return try await repo.createGoal(title: trimmed, targetHours: targetHours)
    }

    func update(goal: Goal) async throws {
        let trimmed = goal.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw AppError.invalidInput("Title cannot be empty") }
        guard goal.targetHours > 0 else { throw AppError.invalidInput("Target hours must be > 0") }
        var fixed = goal
        fixed.title = trimmed
        try await repo.updateGoal(fixed)
    }

    func delete(goalId: UUID) async throws {
        let count = try await logRepo.countLogs(goalId: goalId)   // ✅ 真约束
        guard count == 0 else {
            throw AppError.operationNotAllowed("This goal has records and cannot be deleted.")
        }
        try await repo.deleteGoal(id: goalId)
    }
}
