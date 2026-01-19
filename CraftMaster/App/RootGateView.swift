import SwiftUI

/// Root container that shows a loading animation until `AppState` finishes initial load.
struct RootGateView: View {
    @EnvironmentObject private var app: AppState
    @State private var revealProgress: Double = 0.0
    @State private var showReveal: Bool = false

    var body: some View {
        ZStack {
            if app.isReady {
                RootTabView()
                    .transition(.opacity)
            } else {
                LoadingScreen()
                    .transition(.opacity)
            }

            // "Canvas reveal" into the main UI.
            if showReveal {
                PixelWipeTransition(progress: revealProgress)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: app.isReady)
        .onChange(of: app.isReady) { _, ready in
            guard ready else { return }
            // Start fully covered, then uncover quickly.
            showReveal = true
            revealProgress = 1.0
            withAnimation(.easeOut(duration: 0.75)) {
                revealProgress = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.80) {
                showReveal = false
            }
        }
    }
}

