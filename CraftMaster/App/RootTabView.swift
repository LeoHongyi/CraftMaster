//
//  RootTabView.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//


import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            GoalListScreen()
                .tabItem { Label("Goals", systemImage: "target") }

            LogHomeScreen()
                .tabItem { Label("Log", systemImage: "pencil") }
        }
    }
}
