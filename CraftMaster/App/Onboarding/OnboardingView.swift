import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) private var scheme
    @Binding var hasSeenOnboarding: Bool

    @State private var page: Int = 0
    @State private var isFinishing = false
    @State private var wipeProgress: Double = 0.0

    private let pageCount = 4

    var body: some View {
        ZStack(alignment: .topTrailing) {
            PixelTheme.bg(scheme).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: PixelTheme.l)

                TabView(selection: $page) {
                    OnboardingPageWelcome()
                        .tag(0)
                    OnboardingPageGoal()
                        .tag(1)
                    OnboardingPageLog()
                        .tag(2)
                    OnboardingPageBadges()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                VStack(spacing: PixelTheme.m) {
                    PixelPageDots(count: pageCount, index: page)

                    PixelButton(primaryCTA, isEnabled: !isFinishing, action: primaryAction)
                }
                .padding(PixelTheme.l)
            }
            .scaleEffect(isFinishing ? 0.985 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isFinishing)

            HStack(spacing: PixelTheme.s) {
                if page < pageCount - 1 {
                    PixelSmallButton("Skip") {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            hasSeenOnboarding = true
                        }
                    }
                }
            }
            .padding(PixelTheme.l)

            if isFinishing {
                PixelWipeTransition(progress: wipeProgress)
                    .transition(.opacity)
            }
        }
    }

    private var primaryCTA: String {
        switch page {
        case 0: return "Start"
        case 1, 2: return "Next"
        default: return "Enter World"
        }
    }

    private func primaryAction() {
        guard !isFinishing else { return }
        if page < pageCount - 1 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                page += 1
            }
        } else {
            finish()
        }
    }

    private func finish() {
        isFinishing = true
        wipeProgress = 0.0

        // Pixel wipe: from bottom-up with a wave front.
        withAnimation(.easeInOut(duration: 0.95)) {
            wipeProgress = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.98) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                hasSeenOnboarding = true
            }
        }
    }
}

// MARK: - Pages

private struct OnboardingPageWelcome: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        OnboardingPageShell(
            icon: "flame.fill",
            iconColor: PixelTheme.accent(scheme),
            title: "WELCOME, CRAFTER!",
            subtitle: "Build mastery, one day at a time."
        ) {
            PixelCard {
                VStack(alignment: .leading, spacing: PixelTheme.s) {
                    Text("Set a quest. Log XP daily. Unlock badges.")
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))

                    HStack(spacing: PixelTheme.m) {
                        PixelIconTile(systemName: "target")
                        PixelIconTile(systemName: "pencil")
                        PixelIconTile(systemName: "trophy.fill")
                    }
                }
            }
        }
    }
}

private struct OnboardingPageGoal: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        OnboardingPageShell(
            icon: "target",
            iconColor: Color(red: 0.19, green: 0.78, blue: 0.88),
            title: "SET A QUEST",
            subtitle: "Choose a skill, set a target (10,000h), track progress."
        ) {
            PixelCard {
                VStack(alignment: .leading, spacing: PixelTheme.s) {
                    HStack {
                        Text("Learn iOS")
                            .font(PixelTheme.titleFont())
                        Spacer()
                        Text("200h")
                            .font(PixelTheme.bodyFont())
                            .foregroundStyle(PixelTheme.secondaryText(scheme))
                    }

                    PixelProgressMini(progress: 0.18, accent: PixelTheme.accent(scheme))

                    Text("Example quest card")
                        .font(.caption.monospaced())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                }
            }
        }
    }
}

private struct OnboardingPageLog: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        OnboardingPageShell(
            icon: "pencil",
            iconColor: Color(red: 0.25, green: 0.46, blue: 0.95),
            title: "LOG YOUR XP",
            subtitle: "Log minutes daily. Offline-first. No friction."
        ) {
            PixelCard {
                VStack(alignment: .leading, spacing: PixelTheme.s) {
                    HStack {
                        PixelIconTile(systemName: "plus")
                        Text("+10 XP")
                            .font(PixelTheme.titleFont())
                            .foregroundStyle(PixelTheme.accent(scheme))
                        Spacer()
                        Text("Today")
                            .font(PixelTheme.bodyFont())
                            .foregroundStyle(PixelTheme.secondaryText(scheme))
                    }

                    Text("One tap to save minutes")
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                }
            }
            .overlay(alignment: .topTrailing) {
                XPFloat()
                    .offset(x: -12, y: -10)
            }
        }
    }
}

private struct OnboardingPageBadges: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        OnboardingPageShell(
            icon: "trophy.fill",
            iconColor: PixelTheme.accent(scheme),
            title: "EARN BADGES",
            subtitle: "Streak, milestones, achievements, AI coach summaries."
        ) {
            PixelCard {
                VStack(alignment: .leading, spacing: PixelTheme.s) {
                    HStack(spacing: PixelTheme.m) {
                        PixelIconTile(systemName: "flame.fill")
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Streak & Milestones")
                                .font(PixelTheme.titleFont())
                            Text("Keep the combo going")
                                .font(PixelTheme.bodyFont())
                                .foregroundStyle(PixelTheme.secondaryText(scheme))
                        }
                        Spacer()
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                PixelConfetti()
                    .padding(.trailing, 8)
                    .padding(.top, 8)
            }
        }
    }
}

// MARK: - Reusable layout & components

private struct OnboardingPageShell<Content: View>: View {
    @Environment(\.colorScheme) private var scheme

    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let content: Content

    init(icon: String, iconColor: Color, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(spacing: PixelTheme.l) {
            Spacer().frame(height: PixelTheme.m)

            PixelIconTile(systemName: icon, size: 56, tint: iconColor)

            VStack(spacing: PixelTheme.s) {
                Text(title)
                    .font(.system(size: 30, weight: .heavy, design: .monospaced))
                    .textCase(.uppercase)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(PixelTheme.bodyFont())
                    .foregroundStyle(PixelTheme.secondaryText(scheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, PixelTheme.l)
            }

            content
                .padding(.horizontal, PixelTheme.l)

            Spacer()
        }
    }
}

struct PixelIconTile: View {
    @Environment(\.colorScheme) private var scheme
    let systemName: String
    var size: CGFloat = 48
    var tint: Color? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(PixelTheme.card(scheme))
                .overlay(
                    PixelBorder()
                        .stroke(PixelTheme.border(scheme), lineWidth: 2)
                )

            Image(systemName: systemName)
                .font(.system(size: size * 0.45, weight: .bold))
                .foregroundStyle(tint ?? PixelTheme.accent(scheme))
        }
        .frame(width: size, height: size)
    }
}

struct PixelProgressMini: View {
    @Environment(\.colorScheme) private var scheme
    let progress: Double // 0...1
    let accent: Color

    var body: some View {
        GeometryReader { geo in
            let h: CGFloat = 12
            let px = PixelTheme.px
            let blocks = max(1, Int((geo.size.width / px).rounded(.down)))
            let filled = Int((Double(blocks) * progress).rounded(.down))

            HStack(spacing: 2) {
                ForEach(0..<blocks, id: \.self) { i in
                    Rectangle()
                        .fill(i < filled ? accent : PixelTheme.border(scheme).opacity(0.25))
                        .frame(height: h)
                }
            }
        }
        .frame(height: 12)
    }
}

struct PixelPageDots: View {
    @Environment(\.colorScheme) private var scheme
    let count: Int
    let index: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Rectangle()
                    .fill(i == index ? PixelTheme.accent(scheme) : PixelTheme.border(scheme).opacity(0.35))
                    .frame(width: 10, height: 10)
                    .overlay(
                        PixelBorder(pixel: 2, cornerPixels: 1)
                            .stroke(PixelTheme.border(scheme).opacity(0.6), lineWidth: 1)
                    )
            }
        }
        .accessibilityLabel("Onboarding page \(index + 1) of \(count)")
    }
}

private struct PixelSmallButton: View {
    @Environment(\.colorScheme) private var scheme
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(PixelTheme.bodyFont())
                .foregroundStyle(PixelTheme.secondaryText(scheme))
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(PixelTheme.card(scheme))
                .overlay(
                    PixelBorder(pixel: 3, cornerPixels: 1)
                        .stroke(PixelTheme.border(scheme), lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct XPFloat: View {
    @Environment(\.colorScheme) private var scheme
    @State private var up = false

    var body: some View {
        Text("+10 XP")
            .font(.caption.monospaced())
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(PixelTheme.card(scheme))
            .overlay(PixelBorder(pixel: 3, cornerPixels: 1).stroke(PixelTheme.border(scheme), lineWidth: 2))
            .foregroundStyle(PixelTheme.accent(scheme))
            .offset(y: up ? -8 : 0)
            .opacity(up ? 0.0 : 1.0)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0).repeatForever(autoreverses: false)) {
                    up = true
                }
            }
    }
}

