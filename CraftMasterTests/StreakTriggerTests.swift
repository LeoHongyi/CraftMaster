//
//  StreakTriggerTests.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import XCTest
@testable import CraftMaster

final class StreakTriggerTests: XCTestCase {

    func testShouldAnimate_onlyWhenIncrease() {
        XCTAssertTrue(StreakTrigger.shouldAnimate(old: 0, new: 1))
        XCTAssertTrue(StreakTrigger.shouldAnimate(old: 3, new: 4))

        XCTAssertFalse(StreakTrigger.shouldAnimate(old: 1, new: 1))
        XCTAssertFalse(StreakTrigger.shouldAnimate(old: 2, new: 1))
    }
}
