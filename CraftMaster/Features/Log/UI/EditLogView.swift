//
//  EditLogView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct EditLogView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    let entry: LogEntry
    let onSave: (Int) -> Void

    @State private var minutesText: String

    init(entry: LogEntry, onSave: @escaping (Int) -> Void) {
        self.entry = entry
        self.onSave = onSave
        _minutesText = State(initialValue: String(entry.minutes))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: PixelTheme.l) {
                    PixelCard {
                        VStack(alignment: .leading, spacing: PixelTheme.s) {
                            Text("Minutes")
                                .font(PixelTheme.bodyFont())
                                .foregroundStyle(PixelTheme.secondaryText(scheme))

                            TextField("Minutes", text: $minutesText)
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

                    PixelButton("Save") {
                        let minutes = Int(minutesText) ?? entry.minutes
                        onSave(minutes)
                        dismiss()
                    }
                }
                .padding(PixelTheme.l)
            }
            .background(PixelTheme.bg(scheme))
            .pixelNavigationTitle("Edit Log")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
