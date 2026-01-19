//
//  AppErrorMappingTests.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import XCTest
@testable import CraftMaster

final class AppErrorMappingTests: XCTestCase {

    func testUserFacingErrorMapping() async {
        let err = AppError.userFacing(.operationNotAllowed("No delete"))
        let (title, message) = await MainActor.run { () -> (String?, String?) in
            let app = AppState(
                goalRepo: InMemoryGoalRepository(),
                logRepo: InMemoryLogRepository(),
                achievementRepo: InMemoryAchievementRepository()
            )
            let presentable = app.performMapForTest(err)
            return (presentable?.title, presentable?.message)
        }

        XCTAssertEqual(title, "Not Allowed")
        XCTAssertEqual(message, "No delete")
    }
}
