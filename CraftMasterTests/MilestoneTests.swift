//
//  MilestoneTests.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//


import XCTest
@testable import CraftMaster

final class MilestoneTests: XCTestCase {
    func testShouldShow_onlyForConfiguredValues() {
        XCTAssertTrue(Milestone.shouldShow(for: 3))
        XCTAssertTrue(Milestone.shouldShow(for: 7))
        XCTAssertTrue(Milestone.shouldShow(for: 14))
        XCTAssertTrue(Milestone.shouldShow(for: 30))

        XCTAssertFalse(Milestone.shouldShow(for: 1))
        XCTAssertFalse(Milestone.shouldShow(for: 2))
        XCTAssertFalse(Milestone.shouldShow(for: 4))
        XCTAssertFalse(Milestone.shouldShow(for: 10))
    }

    func testText_format() {
        XCTAssertEqual(Milestone.text(for: 7), "🔥 7-day streak!")
    }
}
