import Foundation
import Combine

@MainActor
final class GoalListViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded([Goal])
        case failed(String)
    }

    struct AlertState: Equatable, Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    @Published private(set) var state: State = .idle
    @Published var alert: AlertState?

    private let useCase: GoalUseCase

    init(useCase: GoalUseCase) {
        self.useCase = useCase
    }

    func load() {
        state = .loading
        Task { await reload() }
    }

    func addGoal(title: String) {
        Task {
            do {
                _ = try await useCase.create(title: title)
                await reload()
            } catch {
                showError(error)
            }
        }
    }

    func updateGoal(_ goal: Goal) {
        Task {
            do {
                try await useCase.update(goal: goal)
                await reload()
            } catch {
                showError(error)
            }
        }
    }

    func deleteGoal(id: UUID) {
        Task {
            do {
                try await useCase.delete(goalId: id)
                await reload()
            } catch {
                showError(error)
            }
        }
    }

    private func reload() async {
        do {
            let goals = try await useCase.list()
            state = .loaded(goals)
        } catch {
            showError(error)
        }
    }

    private func showError(_ error: Error) {
        let msg = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        alert = .init(title: "Oops", message: msg)
    }
}
