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
    var stubbedInsight: AIInsight = AIInsight(
        summary: "mock summary",
        suggestion: "mock suggestion",
        generatedAt: Date(timeIntervalSince1970: 1)
    )
    var stubbedError: (any Error)?

    func generateInsight(input: AIInsightInput) async throws -> AIInsight {
        called = true
        if let stubbedError { throw stubbedError }
        return stubbedInsight
    }
}
