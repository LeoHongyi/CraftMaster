//
//  LogUseCaseTests.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import XCTest
@testable import CraftMaster

final class LogUseCaseTests: XCTestCase {

    func testUpsert_withNonPositiveMinutes_throwsError() async {
        let repo = InMemoryLogRepository()
        let useCase = LogUseCase(repo: repo)

        do {
            _ = try await useCase.upsert(goalId: UUID(), day: Date(), minutes: 0)
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? AppError, .invalidInput("Minutes must be > 0"))
        }
    }

    func testUpsert_sameDay_overwritesExistingEntry() async throws {
        let repo = InMemoryLogRepository()
        let useCase = LogUseCase(repo: repo)
        let goalId = UUID()

        let day = Date()
        _ = try await useCase.upsert(goalId: goalId, day: day, minutes: 20)
        _ = try await useCase.upsert(goalId: goalId, day: day, minutes: 45)

        let logs = try await repo.listLogs(goalId: goalId)
        XCTAssertEqual(logs.count, 1)
        XCTAssertEqual(logs.first?.minutes, 45)
    }

    func testUpsert_differentDays_createsMultipleEntries() async throws {
        let repo = InMemoryLogRepository()
        let useCase = LogUseCase(repo: repo)
        let goalId = UUID()

        let cal = Calendar.current
        let day1 = Date()
        let day2 = cal.date(byAdding: .day, value: -1, to: day1)!

        _ = try await useCase.upsert(goalId: goalId, day: day1, minutes: 20)
        _ = try await useCase.upsert(goalId: goalId, day: day2, minutes: 30)

        let logs = try await repo.listLogs(goalId: goalId)
        XCTAssertEqual(logs.count, 2)
    }
}
