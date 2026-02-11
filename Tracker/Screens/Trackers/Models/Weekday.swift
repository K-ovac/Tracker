//
//  Weekday.swift
//  Tracker
//
//  Created by Максим Лозебной on 07.02.2026.
//

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
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday: 
            return "Среда"
        case .thursday: 
            return "Четверг"
        case .friday: 
            return "Пятница"
        case .saturday: 
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    // MARK: short
    var shortTitle: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}
