//
//  DefaultsService.swift
//  Tracker
//
//  Created by Максим Лозебной on 24.02.2026.
//

import Foundation

final class DefaultsService {
    //MARK: - UD
    private let storage: UserDefaults = .standard
    
    //MARK: - UD Keys
    private enum Keys: String {
        case sawOnboard
        
        var value: String { rawValue }
    }
    
    //MARK: - UD Onboard
    var sawOnboard: Bool {
        get {
            storage.bool(forKey: Keys.sawOnboard.value)
        }
        set {
            storage.set(newValue, forKey: Keys.sawOnboard.value)
        }
    }
}
