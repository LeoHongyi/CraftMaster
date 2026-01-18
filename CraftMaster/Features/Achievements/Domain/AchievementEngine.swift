//
//  AchievementEngine.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AchievementContext: Equatable, Sendable {
    let currentStreak: Int
    let bestStreak: Int
}

struct AchievementEngine {
    let catalog: [AchievementDefinition]

    init(catalog: [AchievementDefinition] = AchievementCatalog.all) {
        self.catalog = catalog
    }

    func newlyUnlocked(
        context: AchievementContext,
        alreadyUnlockedIds: Set<String>,
        now: Date = Date()
    ) -> [AchievementUnlock] {
        var results: [AchievementUnlock] = []

        for def in catalog {
            guard !alreadyUnlockedIds.contains(def.id) else { continue }

            let unlocked: Bool
            switch def.condition {
            case .streakAtLeast(let n):
                // 用 bestStreak 更合理：用户曾经达到过就该解锁
                unlocked = context.bestStreak >= n
            }

            if unlocked {
                results.append(.init(id: def.id, unlockedAt: now))
            }
        }

        return results
    }
}
