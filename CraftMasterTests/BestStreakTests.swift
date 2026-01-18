//
//  BestStreakTests.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import XCTest
@testable import CraftMaster

final class BestStreakTests: XCTestCase {

    func testBestStreak_withGaps_returnsLongestRun() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let achievementRepo = InMemoryAchievementRepository()
        let app = await MainActor.run { AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: achievementRepo) }

        let cal = Calendar.current
        let today = Date()

        // 连续 2 天（today, yesterday）
        _ = try await logRepo.upsertLog(goalId: UUID(), day: today, minutes: 10)
        _ = try await logRepo.upsertLog(goalId: UUID(), day: cal.date(byAdding: .day, value: -1, to: today)!, minutes: 10)

        // 断一天，然后连续 3 天（-3, -4, -5）
        _ = try await logRepo.upsertLog(goalId: UUID(), day: cal.date(byAdding: .day, value: -3, to: today)!, minutes: 10)
        _ = try await logRepo.upsertLog(goalId: UUID(), day: cal.date(byAdding: .day, value: -4, to: today)!, minutes: 10)
        _ = try await logRepo.upsertLog(goalId: UUID(), day: cal.date(byAdding: .day, value: -5, to: today)!, minutes: 10)

        await app.reloadAll()

        let best = await MainActor.run { app.bestStreak() }
        XCTAssertEqual(best, 3)
    }
}
