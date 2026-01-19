//
//  JSONLogMigrationTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class JSONLogMigrationTests: XCTestCase {

    func testMigration_fromV1Array_toV2Persisted() async throws {
        let filename = "logs_migration_test_\(UUID().uuidString).json"
        let repo = JSONLogRepository(filename: filename)

        // 手工写入一个 v1 文件：直接数组 [LogEntryV1]
        let v1: [LogEntryV1] = [
            .init(
                id: UUID(),
                goalId: UUID(),
                day: Date(),
                minutes: 30,
                createdAt: Date(timeIntervalSince1970: 100)
            )
        ]

        // 写到 repo 同一个 document 文件路径
        // 这里我们需要复用 repo 的路径：最简单做法是再 new 一个 helper repo2
        // 但 repo 的 fileURL 是 private，测试拿不到，所以我们走一个“可测路径”的策略：
        // ——在 JSONLogRepository 里提供一个 DEBUG-only init(fileURL:)（Week4 Day2 进阶）
        // 为了今天最小改动，我们改测试策略：通过 repo.upsertLog 写入，再替换文件内容。

        // ✅ 最小可行：先用 repo 正常写一次，确保文件存在
        _ = try await repo.upsertLog(goalId: v1[0].goalId, day: v1[0].day, minutes: 1)

        // 然后用 FileManager 找到 documents/filename 覆盖成 v1 内容
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent(filename)

        let data = try JSONEncoder().encode(v1)
        try data.write(to: url, options: [.atomic])

        // 读：应该触发迁移
        let logs = try await repo.listLogs(goalId: nil)
        XCTAssertEqual(logs.count, 1)
        XCTAssertEqual(logs[0].minutes, 30)
        XCTAssertEqual(logs[0].updatedAt, logs[0].createdAt)

        // 再读一次：应该已经写回 v2 容器且可读
        let logs2 = try await repo.listLogs(goalId: nil)
        XCTAssertEqual(logs2.count, 1)
        XCTAssertEqual(logs2[0].minutes, 30)
    }
}
