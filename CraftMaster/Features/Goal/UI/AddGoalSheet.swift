import SwiftUI

struct AddGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    @State private var title: String = ""
    let onSubmit: (String) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: PixelTheme.l) {
                    PixelCard {
                        VStack(alignment: .leading, spacing: PixelTheme.s) {
                            Text("Goal")
                                .font(PixelTheme.bodyFont())
                                .foregroundStyle(PixelTheme.secondaryText(scheme))

                            TextField("e.g. Learn SwiftUI", text: $title)
                                .textInputAutocapitalization(.sentences)
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

                    PixelButton("Add",
                               isEnabled: !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                        onSubmit(title)
                        dismiss()
                    }
                }
                .padding(PixelTheme.l)
            }
            .background(PixelTheme.bg(scheme))
            .pixelNavigationTitle("New Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
