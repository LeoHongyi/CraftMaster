//
//  JSONGoalRepository.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

actor JSONGoalRepository: GoalRepository {

    private let fileURL: URL
    private let currentSchema = 2

    init(filename: String = "goals.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func listGoals() async throws -> [Goal] {
        do {
            let goals = try loadAll()
            return goals.sorted { $0.createdAt > $1.createdAt }
        } catch _ as DecodingError {
            throw AppError.system(.decoding)
        } catch _ as EncodingError {
            throw AppError.system(.encoding)
        } catch {
            throw AppError.system(.io)
        }
    }

    func createGoal(title: String, targetHours: Int) async throws -> Goal {
        do {
            var goals = try loadAll()
            let newGoal = Goal(
                title: title,
                targetHours: targetHours,
                createdAt: Date()
            )
            goals.insert(newGoal, at: 0)
            try persist(goals)
            return newGoal
        } catch _ as DecodingError {
            throw AppError.system(.decoding)
        } catch _ as EncodingError {
            throw AppError.system(.encoding)
        } catch {
            throw AppError.system(.io)
        }
    }

    func updateGoal(_ goal: Goal) async throws {
        do {
            var goals = try loadAll()
            guard let idx = goals.firstIndex(where: { $0.id == goal.id }) else { return }
            goals[idx] = goal
            try persist(goals)
        } catch _ as DecodingError {
            throw AppError.system(.decoding)
        } catch _ as EncodingError {
            throw AppError.system(.encoding)
        } catch {
            throw AppError.system(.io)
        }
    }

    func deleteGoal(id: UUID) async throws {
        do {
            // Soft delete: archive only.
            var goals = try loadAll()
            guard let idx = goals.firstIndex(where: { $0.id == id }) else { return }
            var archived = goals[idx]
            archived.isArchived = true
            goals[idx] = archived
            try persist(goals)
        } catch _ as DecodingError {
            throw AppError.system(.decoding)
        } catch _ as EncodingError {
            throw AppError.system(.encoding)
        } catch {
            throw AppError.system(.io)
        }
    }

    // MARK: - persistence (v2 container + v1 fallback)
    private func loadAll() throws -> [Goal] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)

        // 1) v2: Persisted<[Goal]>
        if let persisted = try? JSONDecoder().decode(Persisted<[Goal]>.self, from: data) {
            return persisted.data
        }

        // 2) v1: raw [Goal] array (older files)
        if let v1 = try? JSONDecoder().decode([Goal].self, from: data) {
            // Write back as v2 to complete migration
            try persistV2(v1)
            return v1
        }

        throw AppError.system(.decoding)
    }

    private func persist(_ goals: [Goal]) throws {
        try persistV2(goals)
    }

    private func persistV2(_ goals: [Goal]) throws {
        let wrapped = Persisted(schemaVersion: currentSchema, data: goals)
        let data = try JSONEncoder().encode(wrapped)
        try data.write(to: fileURL, options: [.atomic])
    }
}
