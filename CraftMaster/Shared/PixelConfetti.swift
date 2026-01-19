//
//  PixelConfetti.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import SwiftUI

struct PixelConfetti: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Rectangle()
                    .frame(width: PixelTheme.px, height: PixelTheme.px)
                    .foregroundStyle(.orange)
                    .offset(offset(for: i))
                    .opacity(animate ? 0 : 1)
                    .scaleEffect(animate ? 0.6 : 1.0)
                    .animation(.easeOut(duration: 0.7).delay(Double(i) * 0.02), value: animate)
            }
        }
        .onAppear { animate = true }
    }

    private func offset(for i: Int) -> CGSize {
        // 固定的 8 个方向（像游戏碎片）
        let vectors: [CGSize] = [
            .init(width: -18, height: -10),
            .init(width: -10, height: -22),
            .init(width: 0, height: -26),
            .init(width: 10, height: -22),
            .init(width: 18, height: -10),
            .init(width: 14, height: 0),
            .init(width: -14, height: 0),
            .init(width: 0, height: -14)
        ]
        let v = vectors[i % vectors.count]
        return animate ? v : .zero
    }
}
