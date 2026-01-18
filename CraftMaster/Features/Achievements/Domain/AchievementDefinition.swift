//
//  AchievementDefinition.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

enum AchievementCondition: Equatable, Hashable, Sendable, Codable {
    case streakAtLeast(Int)
}

struct AchievementDefinition: Identifiable, Equatable, Hashable, Sendable, Codable {
    let id: String
    let title: String
    let description: String
    let iconSystemName: String
    let condition: AchievementCondition
}
