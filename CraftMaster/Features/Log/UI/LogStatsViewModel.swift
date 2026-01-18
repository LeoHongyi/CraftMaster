//
//  LogStatsViewModel.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation
import Combine

@MainActor
final class LogStatsViewModel: ObservableObject {
    @Published private(set) var todayMinutes: Int = 0
    @Published private(set) var weekMinutes: Int = 0
    @Published private(set) var totalMinutes: Int = 0

    private let repo: LogRepository

    init(repo: LogRepository) {
        self.repo = repo
    }

    func load() {
        Task {
            let logs = (try? await repo.listLogs(goalId: nil)) ?? []
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())

            totalMinutes = logs.reduce(0) { $0 + $1.minutes }

            todayMinutes = logs
                .filter { cal.isDate($0.day, inSameDayAs: today) }
                .reduce(0) { $0 + $1.minutes }

            let weekInterval = cal.dateInterval(of: .weekOfYear, for: today)
            if let interval = weekInterval {
                weekMinutes = logs
                    .filter { interval.contains($0.day) }
                    .reduce(0) { $0 + $1.minutes }
            } else {
                weekMinutes = 0
            }
        }
    }
}
