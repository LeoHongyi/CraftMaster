//
//  StatsStressTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class StatsStressTests: XCTestCase {

    func testStatsWithLargeLogSet() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let app = await MainActor.run {
            AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: InMemoryAchievementRepository())
        }

        let gid = UUID()
        let cal = Calendar.current

        for i in 0..<10_000 {
            let day = cal.date(byAdding: .day, value: -(i % 365), to: Date())!
            _ = try await logRepo.upsertLog(goalId: gid, day: day, minutes: 10)
        }

        await app.reloadAll()

        let stats = await MainActor.run { app.stats }
        XCTAssertGreaterThan(stats.totalMinutes, 0)
        XCTAssertGreaterThan(stats.bestStreak, 0)
    }
}
