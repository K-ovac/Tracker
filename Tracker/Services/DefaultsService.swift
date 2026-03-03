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
        
        case bestPeriod
        case perfectDays
        case trackersCompleted
        case avgScore
        
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

//MARK: UD Statistics Trackers
extension DefaultsService {
    //луший период - сколько дней подряд ставились чекбоксы для трекеров
    var bestPeriod: Int {
        get {
            storage.integer(forKey: Keys.bestPeriod.value)
        }
        set {
            storage.set(newValue, forKey: Keys.bestPeriod.value)
        }
    }
    
    //идеальные дни - когда за один день отмечеы все дни, относящиеся к текущей дате
    var perfectDays: Int {
        get {
            storage.integer(forKey: Keys.perfectDays.value)
        }
        set {
            storage.set(newValue, forKey: Keys.perfectDays.value)
        }
    }
    
    //трекеров завершено - количество отмеченных трекеров
    var trackersCompleted: Int {
        get {
            storage.integer(forKey: Keys.trackersCompleted.value)
        }
        set {
            storage.set(newValue, forKey: Keys.trackersCompleted.value)
        }
    }
    
    //среднее значение среди всех отмеченных трекеров
    var avgScore: Int {
        get {
            storage.integer(forKey: Keys.avgScore.value)
        }
        set {
            storage.set(newValue, forKey: Keys.avgScore.value)
        }
    }
}
