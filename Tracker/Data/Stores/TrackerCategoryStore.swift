//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Максим Лозебной on 15.02.2026.
//

import CoreData
//MARK: TrackerCategoryStoreDelegate
protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories()
}

//MARK: Constants
private enum Constants {
    static let catAttribute_1: String = "title"
    static let predicateFormat_1: String = "title == %@"
}

final class TrackerCategoryStore: NSObject {
    //MARK: Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    //MARK: Init
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    //MARK: FetchedResultsController
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: Constants.catAttribute_1, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        self.fetchedResultsController = fetchedResultsController
        
        try? fetchedResultsController.performFetch()
    }
    
    //MARK: Factory methods
    func fetchOrCreateCategory(title: String) -> TrackerCategoryCoreData {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: Constants.predicateFormat_1, title as CVarArg)
        
        if let existing = try? context.fetch(request).first {
            return existing
        }
        
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        category.id = UUID()
        try? context.save()
        return category
    }
    
    func fetchCategories() -> [TrackerCategoryCoreData] {
        return fetchedResultsController?.fetchedObjects ?? []
    }
}

//MARK: Ext NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}
