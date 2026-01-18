//
//  CraftMasterApp.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

@main
struct CraftMasterApp: App {
    // Data
    private let goalRepo = JSONGoalRepository()

    var body: some Scene {
       WindowGroup {
           AppFactory.makeGoalListView()
       }
    }
}
