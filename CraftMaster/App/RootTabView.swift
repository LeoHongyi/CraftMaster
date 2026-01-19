//
//  RootTabView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//


import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    @State private var showToast = false

    var body: some View {
        ZStack(alignment: .top) {
            TabView {
                GoalListScreen()
                    .tabItem { Label("Goals", systemImage: "target") }

                LogHomeScreen()
                    .tabItem { Label("Log", systemImage: "pencil") }

                AchievementsScreen()
                    .tabItem { Label("Achievements", systemImage: "trophy") }
            }

            toastOverlay
        }
        .onChange(of: app.pendingAchievementToasts) { _, _ in
            // 队列变化时尝试展示
            presentNextIfNeeded()
        }
        .onAppear {
            presentNextIfNeeded()
        }
        .alert(item: $app.presentableError) { err in
            Alert(
                title: Text(err.title),
                message: Text(err.message),
                dismissButton: .default(Text("OK")) {
                    app.presentableError = nil
                }
            )
        }
    }

    @ViewBuilder
    private var toastOverlay: some View {
        if showToast, let first = app.pendingAchievementToasts.first {
            PixelCard(padding: PixelTheme.m) {
                HStack(spacing: PixelTheme.m) {
                    Image(systemName: first.iconSystemName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(PixelTheme.accent(scheme))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Unlocked!")
                            .font(PixelTheme.bodyFont())
                            .foregroundStyle(PixelTheme.secondaryText(scheme))

                        Text(first.title)
                            .font(PixelTheme.titleFont())
                    }

                    Spacer()

                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(PixelTheme.accent(scheme))
                }
            }
            .shadow(radius: 10)
            .accessibilityLabel("Achievement unlocked: \(first.title)")
                .padding(.top, 12)
                .padding(.horizontal, PixelTheme.l)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    Haptics.success()
                    app.highlightAchievementId = first.id
                    flashHighlightClear()
                    autoDismiss()
                }
        }
    }

    private func presentNextIfNeeded() {
        guard !app.pendingAchievementToasts.isEmpty else { return }
        if !showToast {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                showToast = true
            }
        }
    }

    private func autoDismiss() {
        // 展示 1.2s 后消失，并弹下一个
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeOut(duration: 0.25)) {
                showToast = false
            }
            // 再稍微等一下，避免动画冲突
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if !app.pendingAchievementToasts.isEmpty {
                    app.pendingAchievementToasts.removeFirst()
                }
                presentNextIfNeeded()
            }
        }
    }
    private func flashHighlightClear() {
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
           if app.highlightAchievementId == app.pendingAchievementToasts.first?.id {
               app.highlightAchievementId = nil
           } else {
               // 不严格也没事，简单清空
               app.highlightAchievementId = nil
           }
       }
   }
}
