//
//  AppFactory.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation
import SwiftUI

@MainActor
enum AppFactory {

    static func makeRootView() -> some View {
        let goalRepo = JSONGoalRepository()
        let logRepo = JSONLogRepository()

        // Goals
        let goalUseCase = GoalUseCase(repo: goalRepo, logRepo: logRepo)
        let goalVM = GoalListViewModel(useCase: goalUseCase)

        // Log
        let logUseCase = LogUseCase(repo: logRepo)
        let logTodayVM = LogTodayViewModel(goalRepo: goalRepo, logUseCase: logUseCase)
        let logHistoryVM = LogHistoryViewModel(repo: logRepo)
        let logStatsVM = LogStatsViewModel(repo: logRepo)

        // 轻量缓存：goalId -> title（Day5 够用，Week2 我们会更优雅）
        var goalTitleCache: [UUID: String] = [:]
        Task {
            let goals = (try? await goalRepo.listGoals()) ?? []
            for g in goals {
                goalTitleCache[g.id] = g.title
            }
        }

        // History（带编辑回写）
        let historyView = LogHistoryView(
            vm: logHistoryVM,
            goalTitleProvider: { goalId in
                goalTitleCache[goalId] ?? "Unknown Goal"
            },
            onEdit: { entry, minutes in
                Task {
                    _ = try? await logUseCase.upsert(goalId: entry.goalId, day: entry.day, minutes: minutes)
                    await MainActor.run {
                        logHistoryVM.load()
                        logStatsVM.load()
                    }
                }
            }
        )

        // Log Home（Today / History / Stats）
        let logHome = LogHomeView(
            todayView: AnyView(LogTodayView(vm: logTodayVM)),
            historyView: AnyView(historyView),
            statsView: AnyView(LogStatsView(vm: logStatsVM))
        )

        return TabView {
            GoalListView(vm: goalVM)
                .tabItem { Label("Goals", systemImage: "target") }

            logHome
                .tabItem { Label("Log", systemImage: "pencil") }
        }
    }
}
