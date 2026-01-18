//
//  PixelBadge.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct PixelBadge: View {
    @Environment(\.colorScheme) private var scheme
    let text: String

    var body: some View {
        PixelCard(padding: PixelTheme.m) {
            HStack(spacing: PixelTheme.s) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                Text(text)
                    .font(PixelTheme.titleFont())
            }
            .foregroundStyle(PixelTheme.accent(scheme))
        }
        // 让“里程碑弹窗”更像一个明显的 PixelCard（边框更亮、阴影更明显）
        .overlay(
            PixelBorder()
                .stroke(PixelTheme.accent(scheme).opacity(0.95), lineWidth: 2)
        )
        .shadow(color: PixelTheme.accent(scheme).opacity(0.25), radius: 10, x: 0, y: 8)
        .fixedSize() // 让 badge 不被父布局拉伸
    }
}
