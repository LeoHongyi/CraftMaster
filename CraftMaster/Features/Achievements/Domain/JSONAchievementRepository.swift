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
        do {
            guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
            let data: Data
            do {
                data = try Data(contentsOf: fileURL)
            } catch {
                let ns = error as NSError
                if ns.domain == NSCocoaErrorDomain && ns.code == NSFileNoSuchFileError {
                    return []
                }
                throw error
            }
            return try JSONDecoder().decode([AchievementUnlock].self, from: data)
        } catch _ as DecodingError {
            throw AppError.system(.decoding)
        } catch _ as EncodingError {
            throw AppError.system(.encoding)
        } catch {
            throw AppError.system(.io)
        }
    }

    func saveUnlocked(_ unlocks: [AchievementUnlock]) async throws {
        do {
            let data = try JSONEncoder().encode(unlocks)
            // Validate decodability before doing an atomic write (avoid persisting corrupted data).
            _ = try JSONDecoder().decode([AchievementUnlock].self, from: data)
            // Ensure directory exists (defensive; Documents should exist, but keep it robust).
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try data.write(to: fileURL, options: [.atomic])
        } catch _ as DecodingError {
            throw AppError.system(.decoding)
        } catch _ as EncodingError {
            throw AppError.system(.encoding)
        } catch {
            throw AppError.system(.io)
        }
    }
}
