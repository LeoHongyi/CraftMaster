import SwiftUI

struct AddGoalSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    let onSubmit: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal") {
                    TextField("e.g. Learn SwiftUI", text: $title)
                        .textInputAutocapitalization(.sentences)
                }
            }
            .navigationTitle("New Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onSubmit(title)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
