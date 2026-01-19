//
//  MockAIRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation
@testable import CraftMaster

final class MockAIRepository: AIRepository {

    private(set) var called: Bool = false
    var stubbedReport: AICoachReport = AICoachReport(
        summary: "mock summary",
        advice: AICoachAdvice(
            tomorrowMinutes: 15,
            intensity: .easy,
            focus: "Build momentum",
            coachNote: "mock note"
        ),
        generatedAt: Date(timeIntervalSince1970: 1)
    )
    var stubbedError: (any Error)?

    func generateReport(input: AIInsightInput) async throws -> AICoachReport {
        called = true
        if let stubbedError { throw stubbedError }
        return stubbedReport
    }
}
