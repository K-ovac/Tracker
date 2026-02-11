//
//  Colors.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.01.2026.
//
import UIKit

enum Colors {

    static var background: UIColor {
        asset("ypWhite")
    }

    static var textPrimary: UIColor {
        asset("ypBlack")
    }

    static var textButton: UIColor {
        asset("ypWhite")
    }
    
    static var backgroundButton: UIColor {
        asset("ypBlack")
    }
    
    static var tabBarTint: UIColor {
        asset("ypWhite")
    }
    
    static var selectedItem: UIColor {
        asset("ypBlue")
    }
    
    static var unselectedItem: UIColor {
        asset("ypGray")
    }
    
    static var tintButton: UIColor {
        asset("ypWhite")
    }
    
    static var backEmoji: UIColor {
        asset("ypWhite_op30")
    }
    
    static var bckgGrayDay: UIColor {
        asset("ypGray_op30")
    }
    
    static var fieldText: UIColor {
        asset("ypGray")
    }

    // MARK: - Private

    private static func asset(_ name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            assertionFailure("Missing color asset: \(name)")
            return .clear
        }
        return color
    }
}
