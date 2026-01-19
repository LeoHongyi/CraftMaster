import XCTest
@testable import CraftMaster

final class LocalAdviceEngineTests: XCTestCase {

    func testAdvice_lowTotalMinutes_returnsEasy15() {
        let engine = LocalAdviceEngine()

        let input = AIInsightInput(
            totalMinutes: 90,
            currentStreak: 0,
            bestStreak: 0,
            last7DaysMinutes: 0,
            goalTitle: "Test"
        )

        let advice = engine.makeAdvice(input: input)
        XCTAssertEqual(advice.tomorrowMinutes, 15)
        XCTAssertEqual(advice.intensity, .easy)
    }

    func testAdvice_highStreak_increasesTarget() {
        let engine = LocalAdviceEngine()

        let input = AIInsightInput(
            totalMinutes: 1000,
            currentStreak: 14,
            bestStreak: 14,
            last7DaysMinutes: 210, // avg 30/day
            goalTitle: "Test"
        )

        let advice = engine.makeAdvice(input: input)
        XCTAssertTrue(advice.tomorrowMinutes >= 40) // 30 + 10 + 10
    }
}

