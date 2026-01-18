//
//  GoalUseCaseTests.swift
//  CraftMasterTests
//
//  Created by leo on 18/1/2026.
//

import XCTest
@testable import CraftMaster

final class GoalUseCaseTests: XCTestCase {

    func testCreateGoal_withEmptyTitle_throwsError() async {
        let repo = InMemoryGoalRepository()
        let useCase = GoalUseCase(repo: repo)

        do {
            _ = try await useCase.create(title: "   ")
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? AppError, .invalidInput("Title cannot be empty"))
        }
    }

    func testCreateGoal_withValidTitle_createsGoal() async throws {
        let repo = InMemoryGoalRepository()
        let useCase = GoalUseCase(repo: repo)

        let goal = try await useCase.create(title: "Test Goal")

        XCTAssertEqual(goal.title, "Test Goal")
    }
}

