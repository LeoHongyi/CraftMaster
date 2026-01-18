//
//  PixelTheme.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

enum PixelTheme {
    // 像素单位：尽量用偶数（2/4/6/8），避免模糊
    static let px: CGFloat = 4

    // 圆角用“像素切角”来模拟：这里用 cornerPixels 控制切多少格
    static let cornerPixels: Int = 2

    // 间距
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16

    // 字体：像素风最稳的默认方案（等宽）
    static func titleFont() -> Font { .system(.headline, design: .monospaced) }
    static func bodyFont() -> Font { .system(.subheadline, design: .monospaced) }
    static func numberFont() -> Font { .system(size: 28, weight: .bold, design: .rounded) }

    // 颜色（根据 Light/Dark 自动适配）
    static func bg(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.black.opacity(0.92) : Color.white
    }

    static func card(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04)
    }

    static func border(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.5)
    }

    static func accent(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.orange.opacity(0.95) : Color.orange
    }

    static func secondaryText(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.6)
    }
}
