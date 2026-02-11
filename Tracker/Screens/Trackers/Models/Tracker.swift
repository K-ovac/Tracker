//
//  Tracker.swift
//  Tracker
//
//  Created by Максим Лозебной on 07.02.2026.
//
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<Weekday>
    let dayCreatedTracker: Date
}
