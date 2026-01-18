//
//  AchievementTile.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import SwiftUI

struct AchievementTile: View {
    @Environment(\.colorScheme) private var scheme
    let item: AchievementViewData

    var body: some View {
        PixelCard(padding: PixelTheme.m) {
            VStack(alignment: .leading, spacing: PixelTheme.s) {
                HStack {
                    Image(systemName: item.iconSystemName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(item.isUnlocked ? PixelTheme.accent(scheme) : PixelTheme.border(scheme))

                    Spacer()

                    if item.isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(PixelTheme.accent(scheme))
                    } else {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(PixelTheme.secondaryText(scheme))
                    }
                }

                Text(item.isUnlocked ? item.title : "???")
                    .font(PixelTheme.titleFont())
                    .foregroundStyle(item.isUnlocked ? Color.primary : PixelTheme.secondaryText(scheme))

                Text(item.isUnlocked ? item.description : "Locked")
                    .font(PixelTheme.bodyFont())
                    .foregroundStyle(PixelTheme.secondaryText(scheme))
                    .lineLimit(2)

                Spacer(minLength: 0)

                if let date = item.unlockedAt, item.isUnlocked {
                    Text("Unlocked: \(format(date))")
                        .font(.caption.monospaced())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                }
            }
            .frame(minHeight: 120) // 保证卡片高度一致，更像游戏陈列
        }
        .opacity(item.isUnlocked ? 1.0 : 0.7)
        .overlay {
            // 锁定态加一层“像素雾化”感觉：不模糊，只降低透明度 + 轻遮罩
            if !item.isUnlocked {
                Rectangle()
                    .fill(.black.opacity(scheme == .dark ? 0.15 : 0.05))
                    .allowsHitTesting(false)
            }
        }
    }

    private func format(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
