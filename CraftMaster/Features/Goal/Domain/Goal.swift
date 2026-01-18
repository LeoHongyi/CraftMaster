import Foundation

struct Goal: Identifiable, Equatable, Hashable, Sendable, Codable {
    let id: UUID
    var title: String
    var targetHours: Int
    var createdAt: Date

    init(id: UUID = UUID(), title: String, targetHours: Int = 10_000, createdAt: Date) {
        self.id = id
        self.title = title
        self.targetHours = targetHours
        self.createdAt = createdAt
    }
}
