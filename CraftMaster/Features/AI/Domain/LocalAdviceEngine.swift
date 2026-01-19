//
//  LocalAdviceEngine.swift
//  CraftMaster
//
//  Created by leo on 19/1/2026.
//

import Foundation

struct LocalAdviceEngine {

    func makeAdvice(input: AIInsightInput) -> AICoachAdvice {
        // last7DaysMinutes: 用于判断近期强度
        let avgPerDay = input.last7DaysMinutes / 7

        // 基线：用近期平均值作为目标，最少 15
        var target = max(15, avgPerDay)

        // streak 越高，略微增加目标
        if input.currentStreak >= 7 { target += 10 }
        if input.currentStreak >= 14 { target += 10 }

        // 如果总量很低，先轻量建立习惯
        if input.totalMinutes < 120 {
            target = 15
        }

        // 强度判断
        let intensity: AICoachAdvice.Intensity
        if target <= 20 { intensity = .easy }
        else if target <= 45 { intensity = .normal }
        else { intensity = .hard }

        // focus：根据 streak 和近7天判断
        let focus: String
        if input.currentStreak == 0 {
            focus = "Start with consistency"
        } else if input.currentStreak < 7 {
            focus = "Build momentum"
        } else {
            focus = "Increase difficulty"
        }

        let note: String
        switch intensity {
        case .easy: note = "Keep it easy — show up and win the day."
        case .normal: note = "Solid session. Focus on one clear outcome."
        case .hard: note = "Big day. Break it into 2 short sessions if needed."
        }

        return AICoachAdvice(
            tomorrowMinutes: target,
            intensity: intensity,
            focus: focus,
            coachNote: note
        )
    }
}
