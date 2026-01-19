//
//  AICoachCard.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import SwiftUI

struct AICoachCard: View {
    @Environment(\.colorScheme) private var scheme

    let status: AppState.AICoachStatus
    let onRefresh: () -> Void

    @State private var expanded: Bool = true

    var body: some View {
        PixelCard {
            VStack(alignment: .leading, spacing: PixelTheme.m) {

                header

                switch status {
                case .idle, .loading:
                    loadingView

                case .ready(let report):
                    reportView(report)

                case .unavailable(let msg):
                    infoView(title: "Coach Locked", message: msg, icon: "lock.fill")

                case .failed(let msg):
                    infoView(title: "Coach Offline", message: msg, icon: "wifi.exclamationmark")
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: PixelTheme.m) {
            PixelIconTile(systemName: "sparkles")
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text("AI Coach")
                    .font(PixelTheme.titleFont())

                Text(expanded ? "Daily summary & next step" : "Tap to expand")
                    .font(PixelTheme.bodyFont())
                    .foregroundStyle(PixelTheme.secondaryText(scheme))
            }

            Spacer()

            // 折叠
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    expanded.toggle()
                }
            } label: {
                Image(systemName: expanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(PixelTheme.secondaryText(scheme))
            }
            .buttonStyle(.plain)

            // 刷新
            Button {
                onRefresh()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(PixelTheme.secondaryText(scheme))
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                expanded.toggle()
            }
        }
    }

    private var loadingView: some View {
        Group {
            if expanded {
                HStack(spacing: PixelTheme.s) {
                    ProgressView()
                    Text("Coach is thinking...")
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                }
            }
        }
    }

    private func reportView(_ report: AICoachReport) -> some View {
        Group {
            if expanded {
                VStack(alignment: .leading, spacing: PixelTheme.s) {
                    sectionTitle("Summary")
                    Text(report.summary)
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))

                    sectionTitle("Tomorrow Plan")
                    Text("• \(report.advice.tomorrowMinutes) minutes")
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                    Text("• Intensity: \(report.advice.intensity.rawValue)")
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                    Text("• Focus: \(report.advice.focus)")
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))

                    sectionTitle("Coach Note")
                    Text(report.advice.coachNote)
                        .font(PixelTheme.bodyFont())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))

                    Text("Updated \(format(report.generatedAt))")
                        .font(.caption.monospaced())
                        .foregroundStyle(PixelTheme.secondaryText(scheme))
                        .padding(.top, 4)
                }
            }
        }
    }

    // (Advice rendering is inlined in `reportView` to match the pixel-bullet style.)

    private func infoView(title: String, message: String, icon: String) -> some View {
        Group {
            if expanded {
                HStack(alignment: .top, spacing: PixelTheme.m) {
                    Image(systemName: icon)
                        .foregroundStyle(PixelTheme.secondaryText(scheme))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(PixelTheme.titleFont())
                        Text(message)
                            .font(PixelTheme.bodyFont())
                            .foregroundStyle(PixelTheme.secondaryText(scheme))
                    }
                    Spacer()
                }
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.caption.monospaced())
            .foregroundStyle(PixelTheme.secondaryText(scheme))
    }

    private func format(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }
}
