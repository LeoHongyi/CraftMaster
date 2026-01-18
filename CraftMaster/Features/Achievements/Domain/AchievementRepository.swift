//
//  AchievementRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

protocol AchievementRepository {
    func listUnlocked() async throws -> [AchievementUnlock]
    func saveUnlocked(_ unlocks: [AchievementUnlock]) async throws
}
