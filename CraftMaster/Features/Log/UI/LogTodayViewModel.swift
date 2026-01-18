//
//  LogTodayViewModel.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation
import Combine

@MainActor
final class LogTodayViewModel: ObservableObject {
    struct AlertState: Equatable, Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    @Published var goals: [Goal] = []
    @Published var selectedGoalId: UUID?
    @Published var minutesText: String = ""
    @Published var alert: AlertState?

    private let goalRepo: GoalRepository
    private let logUseCase: LogUseCase

    init(goalRepo: GoalRepository, logUseCase: LogUseCase) {
        self.goalRepo = goalRepo
        self.logUseCase = logUseCase
    }

    func load() {
        Task {
            do {
                let list = try await goalRepo.listGoals()
                goals = list
                if selectedGoalId == nil { selectedGoalId = list.first?.id }
            } catch {
                showError(error)
            }
        }
    }

    func saveToday() {
        guard let goalId = selectedGoalId else {
            alert = .init(title: "Oops", message: "Please select a goal.")
            return
        }
        let minutes = Int(minutesText) ?? 0

        Task {
            do {
                _ = try await logUseCase.upsert(goalId: goalId, day: Date(), minutes: minutes)
                alert = .init(title: "Saved", message: "Today's log has been saved.")
            } catch {
                showError(error)
            }
        }
    }

    private func showError(_ error: Error) {
        let msg = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        alert = .init(title: "Oops", message: msg)
    }
}
