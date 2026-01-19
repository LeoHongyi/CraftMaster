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

    func load() async throws -> CachedAICoachReport? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            let ns = error as NSError
            if ns.domain == NSCocoaErrorDomain && ns.code == NSFileNoSuchFileError { return nil }
            throw error
        }
        return try JSONDecoder().decode(CachedAICoachReport.self, from: data)
    }

    func save(_ cached: CachedAICoachReport) async throws {
        let data = try JSONEncoder().encode(cached)
        _ = try JSONDecoder().decode(CachedAICoachReport.self, from: data)
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: fileURL, options: [.atomic])
    }

    func clear() async throws {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
