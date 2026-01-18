import SwiftUI

struct LogStatsScreen: View {
    @EnvironmentObject private var app: AppState

    @State private var streakBounce = false
    @State private var showFlamePop = false
    @State private var lastStreak: Int = 0
    @State private var milestoneText: String?
    @State private var showMilestone = false
    #if DEBUG
    @State private var showDebugPanel = false
    #endif
   

    var body: some View {
        List {
            Section {
                streakCard
            }

            Section("Summary") {
                row("Today", "\(app.todayMinutes()) min")
                row("This Week", "\(app.weekMinutes()) min")
                row("Total", "\(app.totalMinutes()) min")
            }
           
        }
        .onAppear {
            lastStreak = app.currentStreak()
        }
        // 当 logs 变化时（保存/编辑/删除）触发
        .onChange(of: app.logs) { _, _ in
           let newStreak = app.currentStreak()

           if StreakTrigger.shouldAnimate(old: lastStreak, new: newStreak) {
               Haptics.light()
               playStreakAnimation()
           }

           if Milestone.shouldShow(for: newStreak), newStreak > lastStreak {
               Haptics.success()
               showMilestoneBadge(newStreak)
           }
            lastStreak = newStreak
        }
         #if DEBUG
         .contentShape(Rectangle())
         .onLongPressGesture(minimumDuration: 1.0) {
             showDebugPanel = true
         }
         .sheet(isPresented: $showDebugPanel) {
             DebugPanelView().environmentObject(app)
         }
         #endif
        .overlay(alignment: .top) {
            if showMilestone, let text = milestoneText {
               PixelBadge(text: text)
                       .padding(.top, 12)
                       .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var streakCard: some View {
       VStack(alignment: .leading, spacing: 10) {
           HStack(spacing: 12) {
               ZStack {
                   if showFlamePop {
                       Image(systemName: "flame.fill")
                           .font(.system(size: 26))
                           .symbolRenderingMode(.multicolor)
                           .transition(.scale.combined(with: .opacity))
                           .offset(y: -2)
                   } else {
                       Image(systemName: "flame")
                           .font(.system(size: 26))
                           .foregroundStyle(.orange)
                   }
               }
               .frame(width: 34)

               VStack(alignment: .leading, spacing: 4) {
                   HStack(alignment: .firstTextBaseline, spacing: 8) {
                       Text("Current Streak")
                           .font(.headline)

                       Text("\(app.currentStreak())")
                           .font(.system(size: 28, weight: .bold, design: .rounded))
                           .scaleEffect(streakBounce ? 1.15 : 1.0)
                           .animation(.spring(response: 0.35, dampingFraction: 0.55), value: streakBounce)

                       Text("day\(app.currentStreak() == 1 ? "" : "s")")
                           .foregroundStyle(.secondary)
                   }

                   Text(streakSubtitle(app.currentStreak()))
                       .font(.subheadline)
                       .foregroundStyle(.secondary)
               }

               Spacer()
           }

           HStack {
               Label("Best", systemImage: "trophy.fill")
                   .foregroundStyle(.secondary)
               Spacer()
               Text("\(app.bestStreak()) days")
                   .foregroundStyle(.secondary)
           }
           .font(.subheadline)
       }
       .padding(.vertical, 6)
   }

    private func streakSubtitle(_ s: Int) -> String {
        if s == 0 { return "Start today — log your time to begin." }
        if s < 7 { return "Keep going — build momentum." }
        return "Amazing — you're on fire 🔥"
    }

    private func playStreakAnimation() {
        // 数字弹跳
        streakBounce = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            streakBounce = false
        }

        // 火焰弹出
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            showFlamePop = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.2)) {
                showFlamePop = false
            }
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundStyle(.secondary)
        }
    }
   
   private func showMilestoneBadge(_ streak: Int) {
       milestoneText = Milestone.text(for: streak)
       withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
           showMilestone = true
       }
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
           withAnimation(.easeOut(duration: 0.25)) {
               showMilestone = false
           }
       }
   }
}
