//
//  FiltersTracker.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.02.2026.
//

enum FiltersTracker: Int, CaseIterable {
    case allTrackers
    case todayTrackers
    case completed
    case notCompleted
}


extension FiltersTracker {
    var filterTitle: String {
        switch self {
        case .allTrackers:
            return L10n.allTrackers
        case .todayTrackers:
            return L10n.todayTrackers
        case .completed:
            return L10n.completedTrackers
        case .notCompleted:
            return L10n.notCompletedTrackers
        }
    }
}
