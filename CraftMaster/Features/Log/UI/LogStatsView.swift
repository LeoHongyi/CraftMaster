//
//  LogStatsView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct LogStatsView: View {
    @StateObject private var vm: LogStatsViewModel

    init(vm: LogStatsViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            Section("Summary") {
                statRow("Today", "\(vm.todayMinutes) min")
                statRow("This Week", "\(vm.weekMinutes) min")
                statRow("Total", "\(vm.totalMinutes) min")
            }
        }
        .onAppear { vm.load() }
    }

    private func statRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundStyle(.secondary)
        }
    }
}
