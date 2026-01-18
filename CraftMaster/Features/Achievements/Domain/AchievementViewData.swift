//
//  AchievementViewData.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AchievementViewData: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let iconSystemName: String
    let isUnlocked: Bool
    let unlockedAt: Date?
}
