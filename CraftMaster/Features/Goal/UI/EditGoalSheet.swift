//
//  EditGoalSheet.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct EditGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

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
            ScrollView {
                VStack(spacing: PixelTheme.l) {
                    PixelCard {
                        VStack(alignment: .leading, spacing: PixelTheme.m) {
                            VStack(alignment: .leading, spacing: PixelTheme.s) {
                                Text("Title")
                                    .font(PixelTheme.bodyFont())
                                    .foregroundStyle(PixelTheme.secondaryText(scheme))

                                TextField("Title", text: $title)
                                    .font(PixelTheme.titleFont())
                                    .textFieldStyle(.plain)
                                    .padding(.vertical, 6)
                                    .overlay(
                                        Rectangle()
                                            .fill(PixelTheme.border(scheme).opacity(0.6))
                                            .frame(height: 2),
                                        alignment: .bottom
                                    )
                            }

                            VStack(alignment: .leading, spacing: PixelTheme.s) {
                                Text("Target Hours")
                                    .font(PixelTheme.bodyFont())
                                    .foregroundStyle(PixelTheme.secondaryText(scheme))

                                TextField("Target Hours", text: $targetHoursText)
                                    .keyboardType(.numberPad)
                                    .font(PixelTheme.titleFont())
                                    .textFieldStyle(.plain)
                                    .padding(.vertical, 6)
                                    .overlay(
                                        Rectangle()
                                            .fill(PixelTheme.border(scheme).opacity(0.6))
                                            .frame(height: 2),
                                        alignment: .bottom
                                    )
                            }
                        }
                    }

                    PixelButton("Save") {
                        let target = Int(targetHoursText) ?? goal.targetHours
                        var updated = goal
                        updated.title = title
                        updated.targetHours = target
                        onSubmit(updated)
                        dismiss()
                    }
                }
                .padding(PixelTheme.l)
            }
            .background(PixelTheme.bg(scheme))
            .pixelNavigationTitle("Edit Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
