import SwiftUI

@MainActor
enum AppFactory {

    static func makeRootView() -> some View {
        let goalRepo = JSONGoalRepository()
        let logRepo = JSONLogRepository()

        let appState = AppState(goalRepo: goalRepo, logRepo: logRepo)

        return RootTabView()
            .environmentObject(appState)
            .onAppear { appState.loadAll() }
    }
}
