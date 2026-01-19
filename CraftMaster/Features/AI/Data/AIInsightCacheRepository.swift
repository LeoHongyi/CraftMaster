//
//  AIInsightCacheRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

actor AIInsightCacheRepository {

    private let fileURL: URL

    init(filename: String = "ai_insight_cache.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func load() async throws -> CachedAIInsight? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(CachedAIInsight.self, from: data)
    }

    func save(_ cached: CachedAIInsight) async throws {
        let data = try JSONEncoder().encode(cached)
        try data.write(to: fileURL, options: [.atomic])
    }

    func clear() async throws {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
