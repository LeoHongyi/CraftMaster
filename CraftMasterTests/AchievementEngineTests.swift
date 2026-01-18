//
//  AchievementEngineTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class AchievementEngineTests: XCTestCase {

    func testNewlyUnlocked_unlocksWhenBestStreakMeetsThreshold() {
        let engine = AchievementEngine(catalog: AchievementCatalog.all)
        let ctx = AchievementContext(currentStreak: 0, bestStreak: 7)

        let newUnlocks = engine.newlyUnlocked(
            context: ctx,
            alreadyUnlockedIds: [],
            now: Date(timeIntervalSince1970: 123)
        )

        let ids = Set(newUnlocks.map { $0.id })
        XCTAssertTrue(ids.contains("streak_3"))
        XCTAssertTrue(ids.contains("streak_7"))
        XCTAssertFalse(ids.contains("streak_14"))
    }

    func testNewlyUnlocked_doesNotDuplicateAlreadyUnlocked() {
        let engine = AchievementEngine(catalog: AchievementCatalog.all)
        let ctx = AchievementContext(currentStreak: 7, bestStreak: 7)

        let newUnlocks = engine.newlyUnlocked(
            context: ctx,
            alreadyUnlockedIds: ["streak_3", "streak_7"],
            now: Date()
        )

        XCTAssertTrue(newUnlocks.isEmpty)
    }
}
