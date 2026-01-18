//
//   LogHistoryScreen.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct LogHistoryScreen: View {
    @EnvironmentObject private var app: AppState
    @State private var editing: LogEntry?
    @State private var alert: SimpleAlert?

    struct SimpleAlert: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    var body: some View {
        List {
            ForEach(app.logs) { log in
                VStack(alignment: .leading, spacing: 6) {
                    Text(app.goalTitle(log.goalId)).font(.headline)
                    Text("\(formatDay(log.day)) • \(log.minutes) min")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture { editing = log }
                .swipeActions {
                    Button(role: .destructive) {
                        Task {
                            do { try await app.deleteLog(id: log.id) }
                            catch { alert = .init(title: "Oops", message: error.localizedDescription) }
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .sheet(item: $editing) { entry in
            EditLogView(entry: entry) { minutes in
                Task {
                    do {
                        try await app.upsertLog(goalId: entry.goalId, day: entry.day, minutes: minutes)
                    } catch {
                        alert = .init(title: "Oops", message: error.localizedDescription)
                    }
                }
            }
        }
        .alert(item: $alert) { a in
            Alert(title: Text(a.title), message: Text(a.message), dismissButton: .default(Text("OK")))
        }
    }

    private func formatDay(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
