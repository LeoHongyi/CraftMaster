//
//  StatsCache.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct StatsCache: Equatable, Sendable {
    var todayMinutes: Int = 0
    var weekMinutes: Int = 0
    var totalMinutes: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
}
