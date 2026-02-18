//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Максим Лозебной on 15.02.2026.
//

import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords()
}

private enum Constants {
    static let storeName: String = "TrackerRecordStore"
    static let recordAttribute_1: String = "date"
    
    static let predicateFormat_1: String = "id == %@"
    static let predicateFormat_2: String = "tracker == %@ AND date >= %@ AND date < %@"
    static let predicateFormat_3: String = "tracker == %@"
}

final class TrackerRecordStore: NSObject {
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: Constants.recordAttribute_1, ascending: true)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        self.fetchedResultsController = frc
        
        try? frc.performFetch()
    }
    
    // MARK: - Public API для контроллера
    func fetchCompletedTrackers() -> [TrackerRecord] {
        let records = fetchedResultsController?.fetchedObjects ?? []
        return records.compactMap { record in
            guard let trackerId = record.tracker?.id, let date = record.date else { return nil }
            return TrackerRecord(trackerId: trackerId, date: date)
        }
    }
    
    func isTrackerCompleted(_ trackerId: UUID, on date: Date) -> Bool {
        let trackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: Constants.predicateFormat_1, trackerId as CVarArg)
        guard let tracker = try? context.fetch(trackerRequest).first else { return false }
        
        let recordRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else { return false }
        
        recordRequest.predicate = NSPredicate(format: Constants.predicateFormat_2, tracker, startOfDay as CVarArg, nextDay as CVarArg)
        
        return (try? context.fetch(recordRequest).first) != nil
    }
    
    func completedDaysCount(for trackerId: UUID) -> Int {
        let trackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: Constants.predicateFormat_1, trackerId as CVarArg)
        guard let tracker = try? context.fetch(trackerRequest).first else { return 0 }
        
        let recordRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        recordRequest.predicate = NSPredicate(format: Constants.predicateFormat_3, tracker)
        return (try? context.count(for: recordRequest)) ?? 0
    }
    
    func toggleRecord(for trackerId: UUID, on date: Date) throws {
        let trackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: Constants.predicateFormat_1, trackerId as CVarArg)
        guard let tracker = try context.fetch(trackerRequest).first else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else { return }
        
        let recordRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        recordRequest.predicate = NSPredicate(
            format: Constants.predicateFormat_2,
            tracker, startOfDay as CVarArg, nextDay as CVarArg
        )
        
        if let existingRecord = try context.fetch(recordRequest).first {
            context.delete(existingRecord)
        } else {
            let newRecord = TrackerRecordCoreData(context: context)
            newRecord.id = UUID()
            newRecord.date = date
            newRecord.tracker = tracker
        }
        
        try context.save()
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateRecords()
    }
}
