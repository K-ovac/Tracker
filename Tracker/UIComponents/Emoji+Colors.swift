//
//  Emoji+Colors.swift
//  Tracker
//
//  Created by Максим Лозебной on 12.02.2026.
//
import UIKit

struct TrackerEmojis {
    static let emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
}

enum TrackerColors: String, CaseIterable {
    case color_section1
    case color_section2
    case color_section3
    case color_section4
    case color_section5
    case color_section6
    case color_section7
    case color_section8
    case color_section9
    case color_section10
    case color_section11
    case color_section12
    case color_section13
    case color_section14
    case color_section15
    case color_section16
    case color_section17
    case color_section18
    
    var uiColor: UIColor {
        UIColor(named: rawValue) ?? .clear
    }
}

enum TrackerSection: Int, CaseIterable {
    case emojis
    case colors
    
    var numberOfItems: Int {
        switch self {
        case .emojis:
            return TrackerEmojis.emojis.count
        case .colors:
            return TrackerColors.allCases.count
        }
    }
    
    var title: String {
        switch self {
        case .emojis:
            return "Emoji"
        case .colors:
            return "Цвет"
        }
    }
}
