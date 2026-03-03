//
//  Weekday.swift
//  Tracker
//
//  Created by Максим Лозебной on 07.02.2026.
//
import Foundation

enum Weekday: Int, CaseIterable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

    // MARK: Days name
extension Weekday {
    // MARK: full
    var fullTitle: String {
        switch self {
        case .monday:
            return L10n.monday
        case .tuesday:
            return L10n.tuesday
        case .wednesday:
            return L10n.wednesday
        case .thursday:
            return L10n.thursday
        case .friday:
            return L10n.friday
        case .saturday:
            return L10n.saturday
        case .sunday:
            return L10n.sunday
        }
    }
    // MARK: short
    var shortTitle: String {
        switch self {
        case .monday:
            return L10n.mon
        case .tuesday:
            return L10n.tue
        case .wednesday:
            return L10n.wed
        case .thursday:
            return L10n.thu
        case .friday:
            return L10n.fri
        case .saturday:
            return L10n.sat
        case .sunday:
            return L10n.sun
        }
    }
    //функция для сортировки пн-пт относительно календаря системы.
    //из-за дублирования в двух экранах была вынесена с свое перечисление
    static func weekdayFrom(date: Date) -> Weekday {
        let mapping: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        let index = Calendar.current.component(.weekday, from: date)
        return mapping[index - 1]
    }
}
