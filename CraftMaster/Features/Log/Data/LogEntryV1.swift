//
//  LogEntryV1.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

// v1: 没有 updatedAt（假设你早期版本少了这个字段）
struct LogEntryV1: Identifiable, Codable {
    let id: UUID
    let goalId: UUID
    let day: Date
    let minutes: Int
    let createdAt: Date
}
