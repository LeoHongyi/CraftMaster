//
//  OrderRobustnessTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class OrderRobustnessTests: XCTestCase {

    func testDeleteAndRecreateGoalDoesNotCrash() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let app = await MainActor.run {
            AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: InMemoryAchievementRepository())
        }

        await app.createGoal(title: "Test")
        let gid = await MainActor.run { app.goals.first!.id }

        await app.upsertLog(goalId: gid, day: Date(), minutes: 10)
        // Soft delete: archive should always work even if the goal has logs.
        await app.archiveGoal(id: gid)

        // 再建一个
        await app.createGoal(title: "New")

        await app.reloadAll()

        let isEmpty = await MainActor.run { app.goals.isEmpty }
        XCTAssertFalse(isEmpty)
    }
}
