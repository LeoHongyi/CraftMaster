import SwiftUI

struct ArchivedGoalsScreen: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss

    @State private var alert: SimpleAlert?

    struct SimpleAlert: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }

    private var archived: [Goal] {
        app.allGoals
            .filter { $0.isArchived }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            Group {
                if archived.isEmpty {
                    ContentUnavailableView(
                        "No Archived Goals",
                        systemImage: "archivebox",
                        description: Text("Archived goals will show up here.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    List {
                        ForEach(archived) { goal in
                            PixelCard(padding: PixelTheme.m) {
                                VStack(alignment: .leading, spacing: PixelTheme.s) {
                                    Text(goal.title)
                                        .font(PixelTheme.titleFont())

                                    Text("Target: \(goal.targetHours)h")
                                        .font(PixelTheme.bodyFont())
                                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .listRowInsets(EdgeInsets(top: PixelTheme.s, leading: PixelTheme.l, bottom: PixelTheme.s, trailing: PixelTheme.l))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing) {
                                Button {
                                    Task {
                                        await app.unarchiveGoal(id: goal.id)
                                    }
                                } label: {
                                    Label("Restore", systemImage: "arrow.uturn.backward")
                                }
                                .tint(PixelTheme.accent(scheme))
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(PixelTheme.bg(scheme))
            .pixelNavigationTitle("Archived Goals")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .alert(item: $alert) { a in
                Alert(title: Text(a.title), message: Text(a.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

