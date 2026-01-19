//
//  LogTodayScreen.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct LogTodayScreen: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme
    @State private var selectedGoalId: UUID?
    @State private var minutesText: String = ""
    @State private var alert: SimpleAlert?

    struct SimpleAlert: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    var body: some View {
        ScrollView {
            VStack(spacing: PixelTheme.l) {
                PixelCard {
                    VStack(alignment: .leading, spacing: PixelTheme.s) {
                        Text("Goal")
                            .font(PixelTheme.bodyFont())
                            .foregroundStyle(PixelTheme.secondaryText(scheme))

                        Picker("Select", selection: $selectedGoalId) {
                            ForEach(app.goals) { g in
                                Text(g.title).tag(Optional(g.id))
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                PixelCard {
                    VStack(alignment: .leading, spacing: PixelTheme.s) {
                        Text("Today")
                            .font(PixelTheme.bodyFont())
                            .foregroundStyle(PixelTheme.secondaryText(scheme))

                        TextField("Minutes (e.g. 45)", text: $minutesText)
                            .keyboardType(.numberPad)
                            .font(PixelTheme.titleFont())
                            .textFieldStyle(.plain)
                            .padding(.vertical, 6)
                            .overlay(
                                Rectangle()
                                    .fill(PixelTheme.border(scheme).opacity(0.6))
                                    .frame(height: 2),
                                alignment: .bottom
                            )
                    }
                }

                PixelButton("Save", isEnabled: selectedGoalId != nil && !app.goals.isEmpty) {
                    Task {
                        do {
                            guard let gid = selectedGoalId else {
                                alert = .init(title: "Oops", message: "Please select a goal.")
                                return
                            }
                            let minutes = Int(minutesText) ?? 0
                            try await app.upsertLog(goalId: gid, day: Date(), minutes: minutes)
                            alert = .init(title: "Saved", message: "Today's log saved.")
                        } catch {
                            alert = .init(title: "Oops", message: error.localizedDescription)
                        }
                    }
                }
            }
            .padding(PixelTheme.l)
        }
        .background(PixelTheme.bg(scheme))
        .onAppear {
            if selectedGoalId == nil {
                selectedGoalId = app.goals.first?.id
            }
        }
        .alert(item: $alert) { a in
            Alert(title: Text(a.title), message: Text(a.message), dismissButton: .default(Text("OK")))
        }
    }
}
