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
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let useCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)

        do {
            _ = try await useCase.create(title: "   ")
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? AppError, .invalidInput("Title cannot be empty"))
        }
    }

    func testCreateGoal_withValidTitle_createsGoal() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let useCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)

        let goal = try await useCase.create(title: "Test Goal")

        XCTAssertEqual(goal.title, "Test Goal")
    }
   
    func testUpdateGoal_withEmptyTitle_throwsError() async {
          let goalRepo = InMemoryGoalRepository()
          let logRepo = InMemoryLogRepository()   // Day2 会新增这个
          let useCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)

          let goal = Goal(title: "Valid", targetHours: 10, createdAt: Date())
          await logRepo._debug_seed([])

          var updated = goal
          updated.title = "   "

          do {
              try await useCase.update(goal: updated)
              XCTFail("Expected error not thrown")
          } catch {
              XCTAssertEqual(error as? AppError, .invalidInput("Title cannot be empty"))
          }
      }

    func testUpdateGoal_withInvalidTargetHours_throwsError() async {
         let goalRepo = InMemoryGoalRepository()
         let logRepo = InMemoryLogRepository()
         let useCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)

         let goal = Goal(title: "Valid", targetHours: 10, createdAt: Date())
         var updated = goal
         updated.targetHours = 0

         do {
            try await useCase.update(goal: updated)
            XCTFail("Expected error not thrown")
         } catch {
            XCTAssertEqual(error as? AppError, .invalidInput("Target hours must be > 0"))
         }
   }

    func testDeleteGoal_whenHasLogs_throwsOperationNotAllowed() async throws {
          let goalRepo = InMemoryGoalRepository()
          let logRepo = InMemoryLogRepository()
          let useCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)

          let goal = try await goalRepo.createGoal(title: "G1", targetHours: 10)

          // 造一条 log，表示该 goal 有记录
          let log = LogEntry(goalId: goal.id, day: Date(), minutes: 30)
          await logRepo._debug_seed([log])

          do {
              try await useCase.delete(goalId: goal.id)
              XCTFail("Expected error not thrown")
          } catch {
              XCTAssertEqual(error as? AppError,
                             .operationNotAllowed("This goal has records and cannot be deleted."))
          }
      }
}

