//
//  AIInsightUseCase.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AIInsightUseCase {

    let repo: AIRepository

    func generateIfNeeded(
        input: AIInsightInput,
        lastGeneratedAt: Date?
    ) async throws -> AIInsight? {

        // 规则 1：学习时间太少，不值得调用
        guard input.totalMinutes >= 60 else { return nil }

        // 规则 2：一天只生成一次
        if let last = lastGeneratedAt {
            let cal = Calendar.current
            if cal.isDateInToday(last) {
                return nil
            }
        }

        return try await repo.generateInsight(input: input)
    }
}
