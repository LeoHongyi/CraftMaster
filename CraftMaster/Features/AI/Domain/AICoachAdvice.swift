//
//  AICoachAdvice.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AICoachAdvice: Codable, Equatable, Sendable {
    enum Intensity: String, Equatable, Sendable, Codable {
        case easy, normal, hard
    }

    let tomorrowMinutes: Int
    let intensity: Intensity
    let focus: String              // 例如 "Build UI", "Core Swift", "Practice consistency"
    let coachNote: String          // 一句鼓励/提醒
}
