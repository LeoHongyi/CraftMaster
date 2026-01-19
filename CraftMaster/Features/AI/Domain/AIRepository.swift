//
//  AIRepository.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

protocol AIRepository {
   func generateReport(input: AIInsightInput) async throws -> AICoachReport
}
