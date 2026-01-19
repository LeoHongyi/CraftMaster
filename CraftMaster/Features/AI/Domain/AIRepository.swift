//
//  AIRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

protocol AIRepository {
    func generateInsight(input: AIInsightInput) async throws -> AIInsight
}
