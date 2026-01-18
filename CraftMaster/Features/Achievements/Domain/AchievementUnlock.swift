//
//  AchievementUnlock.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AchievementUnlock: Identifiable, Equatable, Hashable, Sendable, Codable {
    let id: String              // achievementId
    let unlockedAt: Date
}
