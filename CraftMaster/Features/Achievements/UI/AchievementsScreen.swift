
//
//  Untitled.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import SwiftUI

struct AchievementsScreen: View {
    @EnvironmentObject private var app: AppState

    // 选中成就，用于弹 sheet
    @State private var selected: AchievementViewData?

    // Grid 自适应：最小宽度 150，系统会自动决定列数（2~4列）
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: PixelTheme.m)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: PixelTheme.m) {
                    ForEach(viewData) { item in
                       AchievementTile(item: item, isHighlighted: app.highlightAchievementId == item.id)
                           .onTapGesture { selected = item }
                    }
                }
                .padding(PixelTheme.l)
            }
            .background(PixelTheme.bg(colorScheme))
            .pixelNavigationTitle("Achievements")
            .sheet(item: $selected) { item in
                AchievementDetailSheet(item: item)
            }
        }
    }

    @Environment(\.colorScheme) private var colorScheme

    // 把 catalog + unlocked 合并成 UI 数据
    private var viewData: [AchievementViewData] {
        let unlockedMap: [String: AchievementUnlock] =
            Dictionary(uniqueKeysWithValues: app.unlockedAchievements.map { ($0.id, $0) })

        return AchievementCatalog.all.map { def in
            let unlock = unlockedMap[def.id]
            return AchievementViewData(
                id: def.id,
                title: def.title,
                description: def.description,
                iconSystemName: def.iconSystemName,
                isUnlocked: unlock != nil,
                unlockedAt: unlock?.unlockedAt
            )
        }
    }
}
