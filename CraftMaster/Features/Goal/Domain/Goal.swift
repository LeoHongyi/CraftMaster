import Foundation

struct Goal: Identifiable, Equatable, Hashable, Sendable, Codable {
    let id: UUID
    var title: String
    var targetHours: Int
    var createdAt: Date
    /// Soft-delete flag. Archived goals are hidden from normal UI but remain in storage for logs/stats.
    var isArchived: Bool

    init(id: UUID = UUID(), title: String, targetHours: Int = 10_000, createdAt: Date, isArchived: Bool = false) {
        self.id = id
        self.title = title
        self.targetHours = targetHours
        self.createdAt = createdAt
        self.isArchived = isArchived
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case targetHours
        case createdAt
        case isArchived
    }

    init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try c.decode(UUID.self, forKey: .id)
        self.title = try c.decode(String.self, forKey: .title)
        self.targetHours = try c.decode(Int.self, forKey: .targetHours)
        self.createdAt = try c.decode(Date.self, forKey: .createdAt)
        self.isArchived = try c.decodeIfPresent(Bool.self, forKey: .isArchived) ?? false
    }
}
