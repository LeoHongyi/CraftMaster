//
//  JSONAchievementRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

actor JSONAchievementRepository: AchievementRepository {
    private let fileURL: URL

    init(filename: String = "achievements_unlocked.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func listUnlocked() async throws -> [AchievementUnlock] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([AchievementUnlock].self, from: data)
    }

    func saveUnlocked(_ unlocks: [AchievementUnlock]) async throws {
        let data = try JSONEncoder().encode(unlocks)
        try data.write(to: fileURL, options: [.atomic])
    }
}
