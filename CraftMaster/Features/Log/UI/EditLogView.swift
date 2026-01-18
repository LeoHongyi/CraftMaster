//
//  EditLogView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct EditLogView: View {
    @Environment(\.dismiss) private var dismiss
    let entry: LogEntry
    let onSave: (Int) -> Void

    @State private var minutesText: String

    init(entry: LogEntry, onSave: @escaping (Int) -> Void) {
        self.entry = entry
        self.onSave = onSave
        _minutesText = State(initialValue: String(entry.minutes))
    }

    var body: some View {
        Form {
            Section("Minutes") {
                TextField("Minutes", text: $minutesText)
                    .keyboardType(.numberPad)
            }

            Button("Save") {
                let minutes = Int(minutesText) ?? entry.minutes
                onSave(minutes)
                dismiss()
            }
        }
        .navigationTitle("Edit Log")
    }
}
