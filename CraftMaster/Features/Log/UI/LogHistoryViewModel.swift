//
//  LogHistoryViewModel.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation
import Combine

@MainActor
final class LogHistoryViewModel: ObservableObject {
    struct AlertState: Equatable, Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    @Published private(set) var logs: [LogEntry] = []
    @Published var alert: AlertState?

    private let repo: LogRepository

    init(repo: LogRepository) {
        self.repo = repo
    }

    func load(goalId: UUID? = nil) {
        Task {
            do {
                logs = try await repo.listLogs(goalId: goalId)
            } catch {
                showError(error)
            }
        }
    }

    func delete(id: UUID) {
        Task {
            do {
                try await repo.deleteLog(id: id)
                logs.removeAll { $0.id == id }
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
