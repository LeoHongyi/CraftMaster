import SwiftUI

struct GoalListView: View {
    @StateObject private var vm: GoalListViewModel
    @State private var showAdd = false
    @State private var editingGoal: Goal?

    init(vm: GoalListViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack {
            content
                .pixelNavigationTitle("Goals")
                .toolbar {
                    Button { showAdd = true } label: { Image(systemName: "plus") }
                }
                .sheet(isPresented: $showAdd) {
                    AddGoalSheet { title in vm.addGoal(title: title) }
                }
                .sheet(item: $editingGoal) { goal in
                    EditGoalSheet(goal: goal) { updated in
                        vm.updateGoal(updated)
                    }
                }
                .alert(item: $vm.alert) { alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: .default(Text("OK"))
                    )
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
                Text("Something went wrong").font(.headline)
                Text(message).foregroundStyle(.secondary)
                Button("Retry") { vm.load() }
            }
            .padding()

        case .loaded(let goals):
            if goals.isEmpty {
                ContentUnavailableView("No Goals", systemImage: "target",
                                      description: Text("Tap + to create your first goal."))
            } else {
                List {
                    Section {
                        ForEach(goals) { goal in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(goal.title).font(.headline)
                                Text("Target: \(goal.targetHours)h")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                editingGoal = goal
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    vm.deleteGoal(id: goal.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    editingGoal = goal
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}
