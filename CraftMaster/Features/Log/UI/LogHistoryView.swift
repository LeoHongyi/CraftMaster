//
//  LogHistoryView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct LogHistoryView: View {
    @StateObject private var vm: LogHistoryViewModel
    let goalTitleProvider: (UUID) -> String
    let onEdit: (LogEntry, Int) -> Void

    init(vm: LogHistoryViewModel,
          goalTitleProvider: @escaping (UUID) -> String,
          onEdit: @escaping (LogEntry, Int) -> Void) {
         _vm = StateObject(wrappedValue: vm)
         self.goalTitleProvider = goalTitleProvider
         self.onEdit = onEdit
     }

    var body: some View {
        List {
            ForEach(vm.logs) { log in
                NavigationLink {
                   EditLogView(entry: log, onSave: { minutes in
                       onEdit(log, minutes)
                   })
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(goalTitleProvider(log.goalId))
                            .font(.headline)

                        Text("\(formatDay(log.day)) • \(log.minutes) min")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete { idxSet in
                for idx in idxSet {
                    vm.delete(id: vm.logs[idx].id)
                }
            }
        }
        .onAppear { vm.load() }
        .alert(item: $vm.alert) { a in
            Alert(title: Text(a.title), message: Text(a.message), dismissButton: .default(Text("OK")))
        }
    }

    private func formatDay(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
