//
//  Colors.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.01.2026.
//
import UIKit

enum Colors {

    static var backgroundView: UIColor {
        asset("ypWhite")
    }
    
    static var textPrimary: UIColor {
        asset("ypBlack")
    }
    
    static var buttonBackground: UIColor {
        asset("ypBlack")
    }
    
    static var backgroundEmojiLabelTrackerCell: UIColor {
        asset("ypWhiteOp30")
    }
    
    static var taskLabelTrackerCell: UIColor {
        asset("ypWhiteStatic")
    }
    
    static var backgroungEmojiLabelOptionCell: UIColor {
        asset("ypLightGray")
    }
    
    static var filtersButtonTint: UIColor {
        asset("ypWhiteStatic")
    }
    
    static var filtersButtonBackground: UIColor {
        asset("ypBlue")
    }
    
    static var nameTextFieldBackground: UIColor {
        asset("ypBackground")
    }
    
    static var clearButtonTextFieldBackground: UIColor {
        asset("ypGray")
    }
    
    static var textLimitLabel: UIColor {
        asset("ypRed")
    }
    
    static var optionSubtitleLabelText: UIColor {
        asset("ypGray")
    }
    
    static var optionSeparatorView: UIColor {
        asset("ypGray")
    }
    
    static var buttonText: UIColor {
        asset("ypWhite")
    }
    
    static var cancelButtonText: UIColor {
        asset("ypRed")
    }
    
    static var optionBackground: UIColor {
        asset("ypBackground")
    }
    
    static var inactiveButtonBackground: UIColor {
        asset("ypGray")
    }
    
    static var inactiveButtonText: UIColor {
        asset("ypWhiteStatic")
    }
    
    static var selectedItemTint: UIColor {
        asset("ypBlue")
    }
    
    static var currentIndicatorTint: UIColor {
        asset("ypBlack")
    }
    
    static var inactiveIndicatorTint: UIColor {
        asset("ypGray")
    }
    
    static var pageIndicatorTint: UIColor {
        asset("ypBackground")
    }
    
    static var borderRed: UIColor {
        asset("ypRedBorder")
    }
    
    static var borderGreen: UIColor {
        asset("ypGreenBorder")
    }
    
    static var borderBlue: UIColor {
        asset("ypBlueBorder")
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
