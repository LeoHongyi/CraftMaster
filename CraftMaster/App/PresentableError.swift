//
//  Untitled.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct PresentableError: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
}
