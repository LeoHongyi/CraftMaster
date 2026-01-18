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
}
