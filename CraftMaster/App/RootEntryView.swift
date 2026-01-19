import SwiftUI

/// App entry: shows onboarding on first launch, then gates into the main UI (with loading fallback).
struct RootEntryView: View {
    @EnvironmentObject private var app: AppState
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            } else {
                RootGateView()
            }
        }
    }
}

