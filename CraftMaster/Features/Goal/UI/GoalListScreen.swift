//
//  GoalListScreen.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct GoalListScreen: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var scheme

    @State private var showAdd = false
    @State private var editingGoal: Goal?
    @State private var alert: GoalListViewModel.AlertState? // 复用之前的结构也行
    @State private var showArchived = false

    var body: some View {
        NavigationStack {
            Group {
                if app.goals.isEmpty {
                    ContentUnavailableView(
                        "No Goals Yet",
                        systemImage: "target",
                        description: Text("Create a goal to start tracking and logging your time.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    List {
                        ForEach(app.goals) { goal in
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
                            .contentShape(Rectangle())
                            .onTapGesture { editingGoal = goal }
                            .swipeActions {
                                Button {
                                    Task { await app.archiveGoal(id: goal.id) }
                                } label: {
                                    Label("Archive", systemImage: "archivebox")
                                }
                                .tint(PixelTheme.border(scheme))

                                Button {
                                    editingGoal = goal
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(PixelTheme.bg(scheme))
            .pixelNavigationTitle("Goals")
            .toolbar {
                Button { showAdd = true } label: { Image(systemName: "plus") }
                Button {
                    showArchived = true
                } label: {
                    Image(systemName: "archivebox")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddGoalSheet { title in
                    Task { await app.createGoal(title: title) }
                }
            }
            .sheet(item: $editingGoal) { goal in
                EditGoalSheet(goal: goal) { updated in
                    Task { await app.updateGoal(updated) }
                }
            }
            .alert(item: $alert) { a in
                Alert(title: Text(a.title), message: Text(a.message), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showArchived) {
                ArchivedGoalsScreen()
                    .environmentObject(app)
            }
        }
    }

    private func showError(_ error: Error) {
        let msg = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        alert = .init(title: "Oops", message: msg)
    }
}
