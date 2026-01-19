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
    /// All goals including archived (kept so logs/history can still resolve titles).
    @Published private(set) var allGoals: [Goal] = []
    /// Active (non-archived) goals for normal UI flows.
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var logs: [LogEntry] = []
    @Published private(set) var unlockedAchievements: [AchievementUnlock] = []
    @Published private(set) var lastUnlocked: AchievementUnlock?
    @Published var pendingAchievementToasts: [AchievementDefinition] = []
    @Published var highlightAchievementId: String?
    @Published private(set) var stats: StatsCache = .init()

    // 依赖（Data/Domain）
    private let goalRepo: GoalRepository
    private let logRepo: LogRepository
    private let goalUseCase: GoalUseCase
    private let logUseCase: LogUseCase
    private let achievementRepo: AchievementRepository
    private let achievementEngine = AchievementEngine()

    init(goalRepo: GoalRepository, logRepo: LogRepository, achievementRepo: AchievementRepository) {
        self.goalRepo = goalRepo
        self.logRepo = logRepo
        self.goalUseCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)
        self.logUseCase = LogUseCase(repo: logRepo)
        self.achievementRepo = achievementRepo
    }

    // MARK: - Load
    func loadAll() {
        Task { await reloadAll() }
    }

    func reloadAll() async {
       async let g: Void = loadGoals()
       async let l: Void = loadLogs()
       async let a: Void = loadAchievements()
       await g
       await l
       await a
    }

    func loadGoals() async {
        do {
            let list = try await goalRepo.listGoals()
            allGoals = list
            goals = list.filter { !$0.isArchived }
        } catch {
            // Day1: 简化处理。Week2 Day2 我们会做全局错误流
            print("loadGoals error:", error)
        }
    }

    func loadLogs() async {
       do {
           logs = try await logRepo.listLogs(goalId: nil)
           recomputeStats(from: logs)

       } catch {
           print("loadLogs error:", error)
           stats = .init() // 可选：避免 UI 显示旧数据
       }

       await evaluateAchievementsAfterLogsChanged()
    }
   
   private func evaluateAchievementsAfterLogsChanged() async {
      let context = AchievementContext(
          currentStreak: stats.currentStreak,
          bestStreak: stats.bestStreak
      )

       let unlockedIds = Set(unlockedAchievements.map { $0.id })
       let newUnlocks = achievementEngine.newlyUnlocked(
           context: context,
           alreadyUnlockedIds: unlockedIds,
           now: Date()
       )

       guard !newUnlocks.isEmpty else { return }

       let merged = (unlockedAchievements + newUnlocks)
           .reduce(into: [String: AchievementUnlock]()) { dict, item in
               // 如果重复，保留最早一次也可以；这里简单覆盖无所谓
               dict[item.id] = item
           }
           .values
           .sorted { $0.unlockedAt < $1.unlockedAt }

       do {
           try await achievementRepo.saveUnlocked(merged)
           unlockedAchievements = merged
           // 追加要弹出的成就（按 catalog 顺序或 unlock 顺序都行）
           let newIds = Set(newUnlocks.map { $0.id })
           let defsToToast = AchievementCatalog.all.filter { newIds.contains($0.id) }

           // 避免重复入队：如果队列里已有该 id，就不再加
           let queuedIds = Set(pendingAchievementToasts.map { $0.id })
           let append = defsToToast.filter { !queuedIds.contains($0.id) }

           pendingAchievementToasts.append(contentsOf: append)
           lastUnlocked = newUnlocks.last
       } catch {
           print("saveUnlocked error:", error)
       }
   }

    // MARK: - Helpers
    func goalTitle(_ id: UUID) -> String {
        allGoals.first(where: { $0.id == id })?.title ?? "Unknown Goal"
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

    /// Archive (soft delete) a goal. Logs stay and history/stats keep working.
    func archiveGoal(id: UUID) async throws {
        try await goalUseCase.delete(goalId: id)
        await reloadAll()
    }

    func unarchiveGoal(id: UUID) async throws {
        guard let idx = allGoals.firstIndex(where: { $0.id == id }) else { return }
        var restored = allGoals[idx]
        restored.isArchived = false
        try await goalRepo.updateGoal(restored)
        await loadGoals()
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
   
   func loadAchievements() async {
       do {
           unlockedAchievements = try await achievementRepo.listUnlocked()
       } catch {
           print("loadAchievements error:", error)
       }
   }
   
   private func recomputeStats(from logs: [LogEntry]) {
       let cal = Calendar.current
       let today = cal.startOfDay(for: Date())

       var total = 0
       var todaySum = 0
       var weekSum = 0

       var days = Set<Date>()

       for log in logs {
           total += log.minutes

           let day = cal.startOfDay(for: log.day)
           days.insert(day)

           if cal.isDate(day, inSameDayAs: today) {
               todaySum += log.minutes
           }

           if cal.isDate(day, equalTo: today, toGranularity: .weekOfYear) {
               weekSum += log.minutes
           }
       }

       let current = computeCurrentStreak(from: days, today: today)
       let best = computeBestStreak(from: days)

       stats = StatsCache(
           todayMinutes: todaySum,
           weekMinutes: weekSum,
           totalMinutes: total,
           currentStreak: current,
           bestStreak: best
       )
   }
   
   private func computeCurrentStreak(from days: Set<Date>, today: Date) -> Int {
       let cal = Calendar.current
       guard days.contains(today) else { return 0 }

       var streak = 0
       var cursor = today
       while days.contains(cursor) {
           streak += 1
           cursor = cal.date(byAdding: .day, value: -1, to: cursor)!
       }
       return streak
   }

   private func computeBestStreak(from days: Set<Date>) -> Int {
       let cal = Calendar.current
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
}

#if DEBUG
extension AppState {
    func debugReloadAll() {
        Task { await reloadAll() }
    }

    func debugClearAllLogs() {
        Task {
            do {
                let all = try await logRepo.listLogs(goalId: nil)
                for item in all {
                    try await logRepo.deleteLog(id: item.id)
                }
                await loadLogs()
            } catch {
                print("debugClearAllLogs error:", error)
            }
        }
    }

    func debugSeedStreak(days: Int, minutes: Int = 10) {
        guard let gid = goals.first?.id else {
            print("debugSeedStreak: no goals")
            return
        }

        Task {
            let cal = Calendar.current
            for i in 0..<days {
                let day = cal.date(byAdding: .day, value: -i, to: Date())!
                try? await upsertLog(goalId: gid, day: day, minutes: minutes)
            }
        }
    }

    func debugSeedMilestone(_ milestone: Int) {
        debugSeedStreak(days: milestone, minutes: 10)
    }
}
#endif
