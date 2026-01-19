//
//  AIInsightUseCaseTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class AIInsightUseCaseTests: XCTestCase {

    func testGenerateIfNeeded_doesNotCallAI_whenTotalMinutesTooLow() async throws {
        let mock = MockAIRepository()
        let useCase = AICoachUseCase(repo: mock)

        let input = AIInsightInput(
            totalMinutes: 30, // < 60
            currentStreak: 1,
            bestStreak: 1,
            last7DaysMinutes: 30,
            goalTitle: "Test"
        )

        let result = try await useCase.generateIfNeeded(
            input: input,
            lastGeneratedAt: nil
        )

        XCTAssertNil(result)
        XCTAssertFalse(mock.called)
    }

    func testGenerateIfNeeded_callsAI_whenEligible() async throws {
        let mock = MockAIRepository()
        let useCase = AICoachUseCase(repo: mock)

        let input = AIInsightInput(
            totalMinutes: 120,
            currentStreak: 3,
            bestStreak: 3,
            last7DaysMinutes: 120,
            goalTitle: "Test"
        )

        let result = try await useCase.generateIfNeeded(
            input: input,
            lastGeneratedAt: nil
        )

        XCTAssertNotNil(result)
        XCTAssertTrue(mock.called)
    }
}
