//
//  StreakTrigger.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

enum StreakTrigger {
    static func shouldAnimate(old: Int, new: Int) -> Bool {
        new > old
    }
}
