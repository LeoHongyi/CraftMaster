//
//  PixelCard.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct PixelCard<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    let padding: CGFloat
    let content: Content

    init(padding: CGFloat = PixelTheme.m, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(PixelTheme.card(scheme))
            .overlay(
                PixelBorder()
                    .stroke(PixelTheme.border(scheme), lineWidth: 2)
            )
    }
}
