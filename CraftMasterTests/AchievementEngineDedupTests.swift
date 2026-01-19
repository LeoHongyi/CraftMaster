//
//  AchievementEngineDedupTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class AchievementEngineDedupTests: XCTestCase {

    func testNewlyUnlocked_doesNotReturnAlreadyUnlocked() {
        let engine = AchievementEngine(catalog: AchievementCatalog.all)
        let ctx = AchievementContext(currentStreak: 7, bestStreak: 7)

        let unlocks = engine.newlyUnlocked(
            context: ctx,
            alreadyUnlockedIds: ["streak_3"],
            now: Date(timeIntervalSince1970: 1)
        )

        let ids = Set(unlocks.map { $0.id })
        XCTAssertFalse(ids.contains("streak_3"))
        XCTAssertTrue(ids.contains("streak_7"))
    }

    func testNewlyUnlocked_bestStreakUnlocksMultipleAtOnce() {
        let engine = AchievementEngine(catalog: AchievementCatalog.all)
        let ctx = AchievementContext(currentStreak: 30, bestStreak: 30)

        let unlocks = engine.newlyUnlocked(
            context: ctx,
            alreadyUnlockedIds: [],
            now: Date(timeIntervalSince1970: 1)
        )

        let ids = Set(unlocks.map { $0.id })
        XCTAssertTrue(ids.contains("streak_3"))
        XCTAssertTrue(ids.contains("streak_7"))
        XCTAssertTrue(ids.contains("streak_14"))
        XCTAssertTrue(ids.contains("streak_30"))
    }
}
