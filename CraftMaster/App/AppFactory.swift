import SwiftUI

@MainActor
enum AppFactory {

    static func makeRootView() -> some View {
        let goalRepo = JSONGoalRepository()
        let logRepo = JSONLogRepository()

        let achievementRepo = JSONAchievementRepository()
        let appState = AppState(goalRepo: goalRepo, logRepo: logRepo, achievementRepo: achievementRepo)

        return RootTabView()
            .environmentObject(appState)
            .onAppear { appState.loadAll() }
    }
}
