//
//  JSONLogRepositoryTests.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import XCTest
@testable import CraftMaster

final class JSONLogRepositoryTests: XCTestCase {

    func testUpsert_persistsToDisk_andCanBeLoaded() async throws {
        let filename = "logs_test_\(UUID().uuidString).json"
        let repo = JSONLogRepository(filename: filename)

        let goalId = UUID()
        let day = Date()

        _ = try await repo.upsertLog(goalId: goalId, day: day, minutes: 25)

        // 新建一个 repo 实例，模拟“重启”
        let repo2 = JSONLogRepository(filename: filename)
        let logs = try await repo2.listLogs(goalId: goalId)

        XCTAssertEqual(logs.count, 1)
        XCTAssertEqual(logs.first?.minutes, 25)
    }
}
