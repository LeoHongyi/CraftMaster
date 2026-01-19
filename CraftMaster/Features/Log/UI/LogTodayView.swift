//
//  LogTodayView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct LogTodayView: View {
    @StateObject private var vm: LogTodayViewModel

    init(vm: LogTodayViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal") {
                    Picker("Select", selection: $vm.selectedGoalId) {
                        Text("Select a goal").tag(Optional<UUID>.none)
                        ForEach(vm.goals) { g in
                            Text(g.title).tag(Optional(g.id))
                        }
                    }
                }

                Section("Today") {
                    TextField("Minutes (e.g. 45)", text: $vm.minutesText)
                        .keyboardType(.numberPad)
                }

                Section {
                    Button("Save") { vm.saveToday() }
                        .disabled(vm.selectedGoalId == nil)
                }
            }
            .pixelNavigationTitle("Log Today")
            .onAppear { vm.load() }
            .alert(item: $vm.alert) { a in
                Alert(title: Text(a.title), message: Text(a.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}
