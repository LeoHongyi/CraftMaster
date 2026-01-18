//
//  GoalRepository.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation


protocol GoalRepository {
    func listGoals() async throws -> [Goal]
    func createGoal(title: String, targetHours: Int) async throws -> Goal

    func updateGoal(_ goal: Goal) async throws
    func deleteGoal(id: UUID) async throws

    /// 临时：用于 Day3 业务约束（后面会换成 LogRepository）
    func logCount(goalId: UUID) async throws -> Int
}
