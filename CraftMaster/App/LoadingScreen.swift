import SwiftUI

/// Pixel-game style loading screen: a tiny blocky walker marches left→right.
struct LoadingScreen: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            PixelTheme.bg(scheme)
                .ignoresSafeArea()

            VStack(spacing: PixelTheme.l) {
                Spacer()

                PixelWalkerTrack()
                    .frame(height: 140)
                    .padding(.horizontal, PixelTheme.l)

                Text("Loading…")
                    .font(PixelTheme.titleFont())
                    .foregroundStyle(PixelTheme.secondaryText(scheme))

                Spacer()
            }
        }
    }
}

private struct PixelWalkerTrack: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { ctx in
                let t = ctx.date.timeIntervalSinceReferenceDate

                // Speed & looping: 6 seconds per traverse feels readable.
                let speed: Double = 1.0 / 6.0
                let phase = (t * speed).truncatingRemainder(dividingBy: 1.0) // 0...1

                // Map to x across the available width with a bit of offscreen margin.
                let margin: CGFloat = 40
                let x = (-margin) + (geo.size.width + margin * 2) * CGFloat(phase)

                // Walk cycle: 2 frames @ ~6 fps.
                let frame = Int(floor((t * 6).truncatingRemainder(dividingBy: 2)))

                ZStack(alignment: .bottomLeading) {
                    // "Ground" line
                    Rectangle()
                        .fill(PixelTheme.border(scheme).opacity(0.35))
                        .frame(height: 2)
                        .offset(y: -18)

                    // Little blocky character
                    PixelWalkerSprite(frame: frame)
                        .scaleEffect(5.5, anchor: .bottomLeading)
                        .offset(x: x, y: -18)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
    }
}

/// An original tiny blocky character (2-frame walk cycle).
private struct PixelWalkerSprite: View {
    @Environment(\.colorScheme) private var scheme
    let frame: Int

    // 12x12 "sprite" encoded as rows of palette codes.
    // '.' = empty
    // 'S' = skin
    // 'H' = hair/helmet
    // 'T' = shirt
    // 'P' = pants
    // 'B' = boots
    private var sprite: [String] {
        if frame == 0 {
            return [
                "....HHHH....",
                "...HSSSSH...",
                "...HSSSSH...",
                "...HTTTTH...",
                "...HTTTTH...",
                "...HTTTTH...",
                "....PPPP....",
                "...PPPPPP...",
                "..PPPPPPPP..",
                "..BB....BB..",
                ".BBB....BBB.",
                "............",
            ]
        } else {
            return [
                "....HHHH....",
                "...HSSSSH...",
                "...HSSSSH...",
                "...HTTTTH...",
                "...HTTTTH...",
                "...HTTTTH...",
                "....PPPP....",
                "...PPPPPP...",
                "..PPPPPPPP..",
                "..BBB..BB...",
                ".BBB....BBB.",
                "............",
            ]
        }
    }

    private func color(for c: Character) -> Color? {
        switch c {
        case "S": return Color(red: 0.95, green: 0.80, blue: 0.66) // skin
        case "H": return PixelTheme.border(scheme) // dark hair/helmet
        case "T": return PixelTheme.accent(scheme) // shirt
        case "P": return Color(red: 0.25, green: 0.46, blue: 0.95) // pants (blue)
        case "B": return Color.black.opacity(scheme == .dark ? 0.8 : 0.7) // boots
        default: return nil
        }
    }

    var body: some View {
        Canvas { context, _ in
            for (y, row) in sprite.enumerated() {
                for (x, ch) in row.enumerated() {
                    guard let fill = color(for: ch) else { continue }
                    let rect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.fill(Path(rect), with: .color(fill))
                }
            }

            // tiny shadow under feet
            context.fill(
                Path(roundedRect: CGRect(x: 2, y: 11.2, width: 8, height: 0.6), cornerRadius: 0.3),
                with: .color(Color.black.opacity(0.18))
            )
        }
        .frame(width: 12, height: 12)
    }
}

