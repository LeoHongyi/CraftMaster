//
//  CachedAIInsight.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct CachedAIInsight: Codable, Equatable, Sendable {
    let insight: AIInsight
    let day: Date   // startOfDay
}
