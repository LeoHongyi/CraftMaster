//
//  AICoachUseCase.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AICoachUseCase {
    let repo: AIRepository

    func generateIfNeeded(input: AIInsightInput, lastGeneratedAt: Date?) async throws -> AICoachReport? {
        guard input.totalMinutes >= 60 else { return nil }

        if let last = lastGeneratedAt, Calendar.current.isDateInToday(last) {
            return nil
        }

        return try await repo.generateReport(input: input)
    }
}
