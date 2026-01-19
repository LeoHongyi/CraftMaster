//
//  LogHomeScreen.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct LogHomeScreen: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme
    @State private var page: Page = .today

    enum Page: String, CaseIterable, Identifiable {
        case today = "Today"
        case history = "History"
        case stats = "Stats"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("", selection: $page) {
                    ForEach(Page.allCases) { p in
                        Text(p.rawValue).tag(p)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                switch page {
                case .today:
                    LogTodayScreen()
                case .history:
                    LogHistoryScreen()
                case .stats:
                    LogStatsScreen()
                }
            }
            .pixelNavigationTitle("Log")
        }
    }
}
