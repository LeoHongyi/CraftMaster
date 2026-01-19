//
//  LocalAIRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct LocalAIRepository: AIRepository {

    func generateInsight(input: AIInsightInput) async throws -> AIInsight {
        let summary = """
        You've logged \(input.totalMinutes) minutes so far.
        Your current streak is \(input.currentStreak) days.
        """

        let suggestion: String
        if input.currentStreak == 0 {
            suggestion = "Start today with a short session to build momentum."
        } else if input.currentStreak < 7 {
            suggestion = "Try to keep your streak going tomorrow."
        } else {
            suggestion = "Amazing consistency! Consider increasing difficulty."
        }

        return AIInsight(
            summary: summary,
            suggestion: suggestion,
            generatedAt: Date()
        )
    }
}
