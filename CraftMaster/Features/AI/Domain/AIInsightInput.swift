//
//  AIInsightInput.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AIInsightInput: Codable, Equatable, Sendable {
    let totalMinutes: Int
    let currentStreak: Int
    let bestStreak: Int
    let last7DaysMinutes: Int
    let goalTitle: String
}
