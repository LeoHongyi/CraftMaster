//
//  AppState.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//


import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {

    // 数据源
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var logs: [LogEntry] = []

    // 依赖（Data/Domain）
    private let goalRepo: GoalRepository
    private let logRepo: LogRepository
    private let goalUseCase: GoalUseCase
    private let logUseCase: LogUseCase

    init(goalRepo: GoalRepository, logRepo: LogRepository) {
        self.goalRepo = goalRepo
        self.logRepo = logRepo
        self.goalUseCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)
        self.logUseCase = LogUseCase(repo: logRepo)
    }

    // MARK: - Load
    func loadAll() {
        Task { await reloadAll() }
    }

    func reloadAll() async {
        async let g: Void = loadGoals()
        async let l: Void = loadLogs()
        await g
        await l
    }

    func loadGoals() async {
        do {
            goals = try await goalRepo.listGoals()
        } catch {
            // Day1: 简化处理。Week2 Day2 我们会做全局错误流
            print("loadGoals error:", error)
        }
    }

    func loadLogs() async {
        do {
            logs = try await logRepo.listLogs(goalId: nil)
        } catch {
            print("loadLogs error:", error)
        }
    }

    // MARK: - Helpers
    func goalTitle(_ id: UUID) -> String {
        goals.first(where: { $0.id == id })?.title ?? "Unknown Goal"
    }

    // MARK: - Goal Actions
    func createGoal(title: String) async throws {
        _ = try await goalUseCase.create(title: title)
        await reloadAll()
    }

    func updateGoal(_ goal: Goal) async throws {
        try await goalUseCase.update(goal: goal)
        await reloadAll()
    }

    func deleteGoal(id: UUID) async throws {
        try await goalUseCase.delete(goalId: id)
        await reloadAll()
    }

    // MARK: - Log Actions
    func upsertLog(goalId: UUID, day: Date, minutes: Int) async throws {
        _ = try await logUseCase.upsert(goalId: goalId, day: day, minutes: minutes)
        await loadLogs()
    }

    func deleteLog(id: UUID) async throws {
        try await logRepo.deleteLog(id: id)
        await loadLogs()
    }

    // MARK: - Stats
    func todayMinutes() -> Int {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return logs
            .filter { cal.isDate($0.day, inSameDayAs: today) }
            .reduce(0) { $0 + $1.minutes }
    }

    func weekMinutes() -> Int {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let interval = cal.dateInterval(of: .weekOfYear, for: today) else { return 0 }
        return logs
            .filter { interval.contains($0.day) }
            .reduce(0) { $0 + $1.minutes }
    }

    func totalMinutes() -> Int {
        logs.reduce(0) { $0 + $1.minutes }
    }
   
   func currentStreak() -> Int {
      let cal = Calendar.current
      let today = cal.startOfDay(for: Date())
      let days = loggedDaysSet()

      guard days.contains(today) else { return 0 }

      var streak = 0
      var cursor = today
      while days.contains(cursor) {
            streak += 1
            cursor = cal.date(byAdding: .day, value: -1, to: cursor)!
      }
      return streak
   }
   
   func bestStreak() -> Int {
       let cal = Calendar.current
       let days = loggedDaysSet()

       guard !days.isEmpty else { return 0 }

       let sorted = days.sorted() // 从早到晚
       var best = 1
       var current = 1

       for i in 1..<sorted.count {
           let prev = sorted[i - 1]
           let cur = sorted[i]

           if let nextDay = cal.date(byAdding: .day, value: 1, to: prev),
              cal.isDate(nextDay, inSameDayAs: cur) {
               current += 1
               best = max(best, current)
           } else {
               current = 1
           }
       }

       return best
   }
   
   private func loggedDaysSet() -> Set<Date> {
       let cal = Calendar.current
       return Set(logs.map { cal.startOfDay(for: $0.day) })
   }
}
