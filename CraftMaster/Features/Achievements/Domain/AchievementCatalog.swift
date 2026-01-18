//
//  AchievementCatalog.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

enum AchievementCatalog {
    static let all: [AchievementDefinition] = [
        .init(
            id: "streak_3",
            title: "Getting Started",
            description: "Hit a 3-day streak.",
            iconSystemName: "flame",
            condition: .streakAtLeast(3)
        ),
        .init(
            id: "streak_7",
            title: "On Fire",
            description: "Hit a 7-day streak.",
            iconSystemName: "flame.fill",
            condition: .streakAtLeast(7)
        ),
        .init(
            id: "streak_14",
            title: "Two Weeks Strong",
            description: "Hit a 14-day streak.",
            iconSystemName: "bolt.fill",
            condition: .streakAtLeast(14)
        ),
        .init(
            id: "streak_30",
            title: "Legendary",
            description: "Hit a 30-day streak.",
            iconSystemName: "crown.fill",
            condition: .streakAtLeast(30)
        )
    ]
}
