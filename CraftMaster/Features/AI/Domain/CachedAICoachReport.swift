import Foundation

struct CachedAICoachReport: Codable, Equatable, Sendable {
    let report: AICoachReport
    let day: Date   // startOfDay
}

