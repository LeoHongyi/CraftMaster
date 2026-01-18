//
//  LogTodayScreen.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct LogTodayScreen: View {
    @EnvironmentObject private var app: AppState
    @State private var selectedGoalId: UUID?
    @State private var minutesText: String = ""
    @State private var alert: SimpleAlert?

    struct SimpleAlert: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    var body: some View {
        Form {
            Section("Goal") {
                Picker("Select", selection: $selectedGoalId) {
                    ForEach(app.goals) { g in
                        Text(g.title).tag(Optional(g.id))
                    }
                }
            }

            Section("Today") {
                TextField("Minutes (e.g. 45)", text: $minutesText)
                    .keyboardType(.numberPad)
            }

            Button("Save") {
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
            .disabled(selectedGoalId == nil || app.goals.isEmpty)
        }
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
