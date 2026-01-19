import SwiftUI

/// A lightweight "game scene" wipe made of pixel blocks.
/// `progress`: 0 → no cover, 1 → full cover.
struct PixelWipeTransition: View {
    @Environment(\.colorScheme) private var scheme
    let progress: Double

    /// Larger tiles = fewer views = smoother on low-end devices.
    private let tile: CGFloat = max(CGFloat(8), PixelTheme.px * 2)

    var body: some View {
        let bg = PixelTheme.bg(scheme)

        Canvas { context, size in
            let cols = max(1, Int(ceil(size.width / tile)))
            let rows = max(1, Int(ceil(size.height / tile)))

            // Draw per-tile "drop" blocks. This avoids a huge SwiftUI view tree.
            for row in 0..<rows {
                for col in 0..<cols {
                    // 0 at bottom, 1 at top
                    let rowNormFromBottom: Double
                    if rows <= 1 {
                        rowNormFromBottom = 0.0
                    } else {
                        rowNormFromBottom = Double((rows - 1) - row) / Double(rows - 1)
                    }

                    let xNorm: Double
                    if cols <= 1 {
                        xNorm = 0.0
                    } else {
                        xNorm = Double(col) / Double(cols - 1)
                    }

                    // Wavy front so it feels like a game wipe, not a flat curtain.
                    let wave = sin((xNorm * 2.0 * Double.pi * 1.75) + (progress * 2.0 * Double.pi))
                    let front = clamp01(progress + wave * 0.085)

                    // Turn into per-tile "reveal" (staggered band).
                    let band = 0.18
                    let local = clamp01((front - rowNormFromBottom) / band)
                    if local <= 0 { continue }

                    // "Pixel drop" feel: tiles fall a bit as they appear.
                    let drop = (1.0 - local) * Double(tile * 0.9)
                    let alpha = local

                    let rect = CGRect(
                        x: CGFloat(col) * tile,
                        y: CGFloat(row) * tile + CGFloat(drop),
                        width: tile,
                        height: tile
                    )

                    context.opacity = alpha
                    context.fill(Path(rect), with: .color(bg))
                }
            }

            context.opacity = 1.0
        }
        .ignoresSafeArea()
        .allowsHitTesting(true) // blocks taps during transition
    }
}

private func clamp01(_ x: Double) -> Double {
    min(1.0, max(0.0, x))
}

