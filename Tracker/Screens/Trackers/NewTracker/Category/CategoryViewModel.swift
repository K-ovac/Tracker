//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Максим Лозебной on 23.02.2026.
//

final class CategoryViewModel {
    //MARK: Binding Cl
    var onCategoriesChange: (() -> Void)?
    var onSelectCategoryChange: (() -> Void)?
    
    //MARK: Properties
    private var selectedIndex: Int?
    private var createdCategories: [Category] = []
    private let trackerCategoryStore: TrackerCategoryStore
    
    //MARK: INit
    init(store: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = store
        self.trackerCategoryStore.delegate = self
        loadCategories()
    }
    
    //MARK: Factory Methodsx
    func numberOfRows() -> Int {
        createdCategories.count
    }
    
    func category(at index: Int) -> Category {
        createdCategories[index]
    }
    
    func isSelected(index: Int) -> Bool {
        selectedIndex == index
    }
    
    func selectCategory(at index: Int) {
        selectedIndex = index
        onSelectCategoryChange?()
    }
    
    func addCategory(title: String) {
        trackerCategoryStore.fetchOrCreateCategory(title: title)
    }
    
    private func loadCategories() {
        let coreDataCategories = trackerCategoryStore.fetchCategories()
        
        createdCategories = coreDataCategories.compactMap {
            guard let name = $0.title else { return nil }
            return Category(name: name)
        }
        
        onCategoriesChange?()
    }
}

//MARK: Ext TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdateCategories() {
        loadCategories()
    }
}
