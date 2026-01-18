import SwiftUI

struct GoalListView: View {
    @StateObject private var vm: GoalListViewModel
    @State private var showAdd = false

    init(vm: GoalListViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Goals")
                .toolbar {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $showAdd) {
                    AddGoalSheet { title in
                        vm.addGoal(title: title)
                    }
                }
                .onAppear { vm.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            VStack(spacing: 12) {
                Text("Something went wrong")
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("Retry") { vm.load() }
            }
            .padding()

        case .loaded(let goals):
            if goals.isEmpty {
                ContentUnavailableView("No Goals", systemImage: "target", description: Text("Tap + to create your first goal."))
            } else {
                List(goals) { goal in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(goal.title).font(.headline)
                        Text("Target: \(goal.targetHours)h")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}
