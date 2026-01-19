//
//  WeekMinutesEdgeTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class WeekMinutesEdgeTests: XCTestCase {

    func testWeekMinutes_countsOnlyCurrentWeek() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let app = await MainActor.run { AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: InMemoryAchievementRepository()) }

        let cal = Calendar.current
        let today = Date()

        // 本周：今天
        let gid = UUID()
        _ = try await logRepo.upsertLog(goalId: gid, day: today, minutes: 50)

        // 上周：7天前（通常会落到上周）
        let lastWeek = cal.date(byAdding: .day, value: -7, to: today)!
        _ = try await logRepo.upsertLog(goalId: gid, day: lastWeek, minutes: 70)

        await app.reloadAll()

        let week = await MainActor.run { app.stats.weekMinutes }
        XCTAssertEqual(week, 50) // 只算本周
    }
}
