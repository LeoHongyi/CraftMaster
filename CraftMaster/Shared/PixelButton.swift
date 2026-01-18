//
//  PixelButton.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct PixelButton: View {
    @Environment(\.colorScheme) private var scheme

    let title: String
    let isEnabled: Bool
    let action: () -> Void

    @State private var pressed = false

    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button {
            guard isEnabled else { return }
            action()
        } label: {
            Text(title)
                .font(PixelTheme.titleFont())
                .foregroundStyle(isEnabled ? PixelTheme.bg(scheme) : PixelTheme.bg(scheme).opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isEnabled ? PixelTheme.accent(scheme) : PixelTheme.border(scheme).opacity(0.4))
                .overlay(
                    PixelBorder()
                        .stroke(PixelTheme.border(scheme), lineWidth: 2)
                )
                .scaleEffect(pressed ? 0.98 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: pressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
        .opacity(isEnabled ? 1.0 : 0.8)
    }
}
