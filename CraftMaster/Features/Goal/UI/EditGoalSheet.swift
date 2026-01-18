//
//  EditGoalSheet.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct EditGoalSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var targetHoursText: String

    let goal: Goal
    let onSubmit: (Goal) -> Void

    init(goal: Goal, onSubmit: @escaping (Goal) -> Void) {
        self.goal = goal
        self.onSubmit = onSubmit
        _title = State(initialValue: goal.title)
        _targetHoursText = State(initialValue: String(goal.targetHours))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal") {
                    TextField("Title", text: $title)

                    TextField("Target Hours", text: $targetHoursText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let target = Int(targetHoursText) ?? goal.targetHours
                        var updated = goal
                        updated.title = title
                        updated.targetHours = target
                        onSubmit(updated)
                        dismiss()
                    }
                }
            }
        }
    }
}
