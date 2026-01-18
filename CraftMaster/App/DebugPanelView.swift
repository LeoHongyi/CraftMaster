//
//  DebugPanelView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

#if DEBUG
struct DebugPanelView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var seedDays: Int = 3
    @State private var seedMinutes: Int = 10

    var body: some View {
        NavigationStack {
            List {
                Section("Quick Actions") {
                    Button("Reload All (Goals + Logs)") {
                        app.debugReloadAll()
                    }

                    Button(role: .destructive) {
                        app.debugClearAllLogs()
                    } label: {
                        Label("Clear All Logs", systemImage: "trash")
                    }
                }

                Section("Seed Streak") {
                    Stepper("Days: \(seedDays)", value: $seedDays, in: 0...60)
                    Stepper("Minutes: \(seedMinutes)", value: $seedMinutes, in: 1...600)

                    Button("Seed \(seedDays) days streak") {
                        app.debugSeedStreak(days: seedDays, minutes: seedMinutes)
                    }
                }

                Section("Milestones") {
                    HStack {
                        Button("3") { app.debugSeedMilestone(3) }
                        Button("7") { app.debugSeedMilestone(7) }
                        Button("14") { app.debugSeedMilestone(14) }
                        Button("30") { app.debugSeedMilestone(30) }
                    }
                }

                Section("Readouts") {
                    row("Current Streak", "\(app.currentStreak())")
                    row("Best Streak", "\(app.bestStreak())")
                    row("Logs Count", "\(app.logs.count)")
                    row("Today Minutes", "\(app.todayMinutes())")
                    row("Week Minutes", "\(app.weekMinutes())")
                    row("Total Minutes", "\(app.totalMinutes())")
                }
            }
            .navigationTitle("Debug Panel")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
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
}
#endif
