//
//  LogoHomeView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//


import SwiftUI

struct LogHomeView: View {
    enum Page: String, CaseIterable, Identifiable {
        case today = "Today"
        case history = "History"
        case stats = "Stats"
        var id: String { rawValue }
    }

    @State private var page: Page = .today

    let todayView: AnyView
    let historyView: AnyView
    let statsView: AnyView

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
                case .today: todayView
                case .history: historyView
                case .stats: statsView
                }
            }
            .navigationTitle("Log")
        }
    }
}
