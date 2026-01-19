//
//  AchievementDetailSheet.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import SwiftUI

struct AchievementDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    let item: AchievementViewData

    var body: some View {
        NavigationStack {
            VStack(spacing: PixelTheme.l) {
                PixelCard {
                    VStack(spacing: PixelTheme.m) {
                        Image(systemName: item.iconSystemName)
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(item.isUnlocked ? PixelTheme.accent(scheme) : PixelTheme.border(scheme))

                        Text(item.isUnlocked ? item.title : "Locked")
                            .font(.title2.monospaced())
                            .bold()

                        Text(item.isUnlocked ? item.description : "Unlock this achievement by completing its condition.")
                            .font(PixelTheme.bodyFont())
                            .foregroundStyle(PixelTheme.secondaryText(scheme))
                            .multilineTextAlignment(.center)

                        if item.isUnlocked, let date = item.unlockedAt {
                            Text("Unlocked at \(format(date))")
                                .font(.caption.monospaced())
                                .foregroundStyle(PixelTheme.secondaryText(scheme))
                        } else {
                            Text("Not unlocked yet")
                                .font(.caption.monospaced())
                                .foregroundStyle(PixelTheme.secondaryText(scheme))
                        }
                    }
                }

                Spacer()
            }
            .padding(PixelTheme.l)
            .pixelNavigationTitle("Achievement")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    PixelButton("Close") { dismiss() }
                        .frame(width: 120)
                }
            }
        }
    }

    private func format(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }
}
