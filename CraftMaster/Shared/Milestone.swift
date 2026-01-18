//
//  Milestone.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

enum Milestone {
    static let values: Set<Int> = [3, 7, 14, 30]

    static func shouldShow(for streak: Int) -> Bool {
        values.contains(streak)
    }

    static func text(for streak: Int) -> String {
        "🔥 30-DAY-ULTRA-LONG-STREAK-ACHIEVEMENT!"
    }
}
