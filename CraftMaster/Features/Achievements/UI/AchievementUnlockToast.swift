
import SwiftUI

struct AchievementUnlockToast: View {
    @Environment(\.colorScheme) private var scheme
    let achievement: AchievementDefinition

 var body: some View {
    ZStack(alignment: .topTrailing) {
        PixelCard(padding: PixelTheme.m) {
            HStack(spacing: PixelTheme.m) {
                Image(systemName: achievement.iconSystemName)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(PixelTheme.accent(scheme))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlocked!")
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))

                    Text(achievement.title)
                        .font(PixelTheme.titleFont())
                }

                Spacer()

                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(PixelTheme.accent(scheme))
            }
        }

        // 像素碎片，从右上角“迸发”
        PixelConfetti()
            .padding(.trailing, 8)
            .padding(.top, 8)
    }
    .shadow(radius: 10)
 }
}
