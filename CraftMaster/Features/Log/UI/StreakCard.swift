//
//  StreakCard.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct StreakCard: View {
    let current: Int
    let best: Int
    let subtitle: String

    // 动画状态由外部驱动（更可控、更易测）
    let bounce: Bool
    let showFlamePop: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    if showFlamePop {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 26))
                            .symbolRenderingMode(.multicolor)
                            .transition(.scale.combined(with: .opacity))
                            .offset(y: -2)
                    } else {
                        Image(systemName: "flame")
                            .font(.system(size: 26))
                            .foregroundStyle(.orange)
                    }
                }
                .frame(width: 34)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("Current Streak")
                            .font(.headline)

                        Text("\(current)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .scaleEffect(bounce ? 1.15 : 1.0)
                            .animation(.spring(response: 0.35, dampingFraction: 0.55), value: bounce)

                        Text("day\(current == 1 ? "" : "s")")
                            .foregroundStyle(.secondary)
                    }

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            HStack {
                Label("Best", systemImage: "trophy.fill")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(best) days")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
        .padding(.vertical, 6)
    }
}
