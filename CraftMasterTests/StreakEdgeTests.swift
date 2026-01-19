//
//  StreakEdgeTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//


import XCTest
@testable import CraftMaster

final class StreakEdgeTests: XCTestCase {

    func testCurrentStreak_breaksWhenGapExists() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let app = await MainActor.run { AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: InMemoryAchievementRepository()) }

        let cal = Calendar.current
        let today = Date()
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
        let threeDaysAgo = cal.date(byAdding: .day, value: -3, to: today)! // 中间断一天

        let gid = UUID()
        _ = try await logRepo.upsertLog(goalId: gid, day: today, minutes: 10)
        _ = try await logRepo.upsertLog(goalId: gid, day: yesterday, minutes: 10)
        _ = try await logRepo.upsertLog(goalId: gid, day: threeDaysAgo, minutes: 10)

        await app.reloadAll()

        let current = await MainActor.run { app.stats.currentStreak }
        let best = await MainActor.run { app.stats.bestStreak }
        XCTAssertEqual(current, 2)
        XCTAssertEqual(best, 2) // 最长连续也是2
    }
}
