//
//  StreakTests.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import XCTest
@testable import CraftMaster

final class StreakTests: XCTestCase {

    func testStreak_whenNoLogToday_isZero() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let achievementRepo = InMemoryAchievementRepository()

        let app = await MainActor.run { AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: achievementRepo) }

        // 只有昨天
        let cal = Calendar.current
        let yesterday = cal.date(byAdding: .day, value: -1, to: Date())!
        _ = try await logRepo.upsertLog(goalId: UUID(), day: yesterday, minutes: 30)
        await app.loadLogs()
        let streak = await MainActor.run { app.currentStreak() }
        XCTAssertEqual(streak, 0)
    }

    func testStreak_threeDaysContinuous_isThree() async throws {
        let goalRepo = InMemoryGoalRepository()
        let logRepo = InMemoryLogRepository()
        let achievementRepo = InMemoryAchievementRepository()

        let app = await MainActor.run { AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: achievementRepo) }

        let cal = Calendar.current
        let today = Date()
        let day1 = today
        let day2 = cal.date(byAdding: .day, value: -1, to: today)!
        let day3 = cal.date(byAdding: .day, value: -2, to: today)!

        let gid = UUID()
        _ = try await logRepo.upsertLog(goalId: gid, day: day1, minutes: 10)
        _ = try await logRepo.upsertLog(goalId: gid, day: day2, minutes: 10)
        _ = try await logRepo.upsertLog(goalId: gid, day: day3, minutes: 10)

        await app.loadLogs()
        let streak = await MainActor.run { app.currentStreak() }
        XCTAssertEqual(streak, 3)
    }
}
