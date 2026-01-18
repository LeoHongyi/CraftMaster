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

    @Published private(set) var state: State = .idle

    private let useCase: GoalUseCase

    init(useCase: GoalUseCase) {
        self.useCase = useCase
    }

    func load() {
        state = .loading
        Task {
            do {
                let goals = try await useCase.list()
                state = .loaded(goals)
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }

    func addGoal(title: String) {
        Task {
            do {
                _ = try await useCase.create(title: title)
                let goals = try await useCase.list()
                state = .loaded(goals)
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }
}
