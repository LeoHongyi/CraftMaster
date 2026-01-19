//
//  AICoachReport.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AICoachReport: Codable, Equatable, Sendable {
    let summary: String
    let advice: AICoachAdvice
    let generatedAt: Date
}
