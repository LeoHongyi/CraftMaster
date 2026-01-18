//
//  Haptics.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//


import UIKit

enum Haptics {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
