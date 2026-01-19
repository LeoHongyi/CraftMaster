import SwiftUI

@MainActor
enum AppFactory {

    static func makeRootView() -> some View {
        let goalRepo = JSONGoalRepository()
        let logRepo = JSONLogRepository()

        let achievementRepo = JSONAchievementRepository()
        let appState = AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: achievementRepo)

        return RootEntryView()
            .environmentObject(appState)
            .onAppear { appState.loadAll() }
    }
}
