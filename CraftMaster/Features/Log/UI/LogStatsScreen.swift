//
//  LogStatsScreen.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//


import SwiftUI

struct LogStatsScreen: View {
    @EnvironmentObject private var app: AppState

    var body: some View {
        List {
            Section("Summary") {
                row("Today", "\(app.todayMinutes()) min")
                row("This Week", "\(app.weekMinutes()) min")
                row("Total", "\(app.totalMinutes()) min")
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
