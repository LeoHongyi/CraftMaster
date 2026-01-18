//
//  GoalListScreen.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct GoalListScreen: View {
    @EnvironmentObject private var app: AppState

    @State private var showAdd = false
    @State private var editingGoal: Goal?
    @State private var alert: GoalListViewModel.AlertState? // 复用之前的结构也行

    var body: some View {
        NavigationStack {
            List {
                ForEach(app.goals) { goal in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(goal.title).font(.headline)
                        Text("Target: \(goal.targetHours)h")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture { editingGoal = goal }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                do { try await app.deleteGoal(id: goal.id) }
                                catch { showError(error) }
                            }
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
            .navigationTitle("Goals")
            .toolbar {
                Button { showAdd = true } label: { Image(systemName: "plus") }
            }
            .sheet(isPresented: $showAdd) {
                AddGoalSheet { title in
                    Task {
                        do { try await app.createGoal(title: title) }
                        catch { showError(error) }
                    }
                }
            }
            .sheet(item: $editingGoal) { goal in
                EditGoalSheet(goal: goal) { updated in
                    Task {
                        do { try await app.updateGoal(updated) }
                        catch { showError(error) }
                    }
                }
            }
            .alert(item: $alert) { a in
                Alert(title: Text(a.title), message: Text(a.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func showError(_ error: Error) {
        let msg = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        alert = .init(title: "Oops", message: msg)
    }
}
