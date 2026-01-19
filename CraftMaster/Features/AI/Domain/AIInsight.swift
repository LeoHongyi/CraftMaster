//
//  AIInsight.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct AIInsight: Codable, Equatable, Sendable {
    let summary: String          // 学习总结
    let suggestion: String       // 下一步建议
    let generatedAt: Date
}
