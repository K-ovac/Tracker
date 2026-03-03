//
//  Statistics.swift
//  Tracker
//
//  Created by Максим Лозебной on 02.03.2026.
//

struct StatisticModel {
    let count: Int
    let title: String
}

enum Statistics: Int, CaseIterable {
    case bestPeriod, perfectDays, trackersCompleted, avgScore
}

extension Statistics {
    var statsTitle: String {
        switch self {
        case .bestPeriod: return L10n.bestPeriod
        case .perfectDays: return L10n.perfectDays
        case .trackersCompleted: return L10n.trackersCompleted
        case .avgScore: return L10n.avgScore
        }
    }
}
