//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Максим Лозебной on 15.02.2026.
//
import CoreData
import UIKit

private enum Constants {
    static let pcName = "TrackerModel"
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: Constants.pcName)
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Save error:", error)
            context.rollback()
        }
    }
    
}

extension UIColor {
    func encode() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    static func decode(from data: Data?) -> UIColor? {
        guard let data = data else { return nil }
        
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

extension TrackerCoreData {
    func setColor(_ color: UIColor) {
        self.color = color.encode()
    }
    
    func getColor() -> UIColor? {
        UIColor.decode(from: self.color)
    }
    
    func setSchedule(_ schedule: Set<Weekday>) {
        let intArray = schedule.map { $0.rawValue }
        self.shedule = try? NSKeyedArchiver.archivedData(withRootObject: intArray, requiringSecureCoding: false)
    }
    
    func getSchedule() -> Set<Weekday> {
        guard let data = shedule,
              let intArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [Int] else {
            return []
        }
        
        return Set(intArray.compactMap { Weekday(rawValue: $0) })
    }
}
