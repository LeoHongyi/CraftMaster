//
//  AppFactory.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

@MainActor
enum AppFactory {

    static func makeGoalListView() -> GoalListView {
        let repo = JSONGoalRepository()
        let useCase = GoalUseCase(repo: repo)
        let vm = GoalListViewModel(useCase: useCase)
        return GoalListView(vm: vm)
    }
}
