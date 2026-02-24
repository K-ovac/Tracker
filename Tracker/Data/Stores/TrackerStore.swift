//
//  TrackerStore.swift
//  Tracker
//
//  Created by Максим Лозебной on 15.02.2026.
//

import CoreData
import UIKit

//MARK: TrackerStoreDelegate
protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers()
}

//MARK: Constants
private enum Constants {
    static let catAttribute_1: String = "trackerCategory.title"
    static let trackerAttribute_1: String = "dayCreatedAt"
    static let predicateFormat_1: String = "id == %@"
}

final class TrackerStore: NSObject {
    //MARK: Properties
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let categoryStore = TrackerCategoryStore()
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    //MARK: Init
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    //MARK: FetchedResultsController
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: Constants.catAttribute_1, ascending: true),
            NSSortDescriptor(key: Constants.trackerAttribute_1, ascending: true),
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: Constants.catAttribute_1,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        self.fetchedResultsController = fetchedResultsController
    }
    
    //MARK: Factory methods
    func createTracker(tracker: Tracker, categoryTitle: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.setColor(tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.setSchedule(tracker.schedule)
        trackerCoreData.dayCreatedAt = tracker.dayCreatedTracker
        
        let categoryCoreData = categoryStore.fetchOrCreateCategory(title: categoryTitle)
        trackerCoreData.trackerCategory = categoryCoreData
        
        try context.save()
    }
    
    func fetchTracker(id: UUID) -> Tracker? {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: Constants.predicateFormat_1, id as CVarArg)
        
        guard let trackerCoreData = try? context.fetch(request).first else {
            return nil
        }
        
        return Tracker(
            id: trackerCoreData.id ?? UUID(),
            name: trackerCoreData.name ?? "",
            color: trackerCoreData.getColor() ?? .clear,
            emoji: trackerCoreData.emoji ?? "",
            schedule: trackerCoreData.getSchedule(),
            dayCreatedTracker: trackerCoreData.dayCreatedAt ?? Date())
    }
    
    func fetchTrackersByCategory() throws -> [TrackerCategory] {
        guard let sections = fetchedResultsController?.sections else { return [] }
        
        return sections.compactMap { section in
            guard let trackersCoreData = section.objects as? [TrackerCoreData] else { return nil }
            
            let trackers = trackersCoreData.compactMap { coreData -> Tracker? in
                guard let id = coreData.id,
                      let name = coreData.name,
                      let emoji = coreData.emoji,
                      let color = coreData.getColor() else {
                    return nil
                }
                
                return Tracker(
                    id: id,
                    name: name,
                    color: color,
                    emoji: emoji,
                    schedule: coreData.getSchedule(),
                    dayCreatedTracker: coreData.dayCreatedAt ?? Date()
                )
            }
            
            return TrackerCategory(
                title: section.name,
                trackers: trackers
            )
        }
    }
}

//MARK: Ext NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}
