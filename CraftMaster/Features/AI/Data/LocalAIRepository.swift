//
//  LocalAIRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct LocalAIRepository: AIRepository {

    private let engine = LocalAdviceEngine()

    func generateReport(input: AIInsightInput) async throws -> AICoachReport {
        let summary = """
        Quest: \(input.goalTitle)
        Total: \(input.totalMinutes) min
        Streak: \(input.currentStreak) (best \(input.bestStreak))
        Last 7 days: \(input.last7DaysMinutes) min
        """

        let advice = engine.makeAdvice(input: input)

        return AICoachReport(
            summary: summary,
            advice: advice,
            generatedAt: Date()
        )
    }
}
