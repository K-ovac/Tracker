//
//  FiltersTrackerViewModel.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.02.2026.
//

final class FiltersTrackerViewModel {
    
    var onFilterChanged: (() -> Void)?
    
    private var selectedIndex: Int?
    private let filters = FiltersTracker.allCases
    
    //MARK: Init
    init(currentFilter: FiltersTracker) {
        selectedIndex = filters.firstIndex(of: currentFilter)
    }
    
    //MARK: Methods
    //количество ячеек из FiltersTracker
    func numberOfRows() -> Int {
        filters.count
    }
    
    //имена фильтров
    func titleForRow(at index: Int) -> String {
        filters[index].filterTitle
    }
    
    //статус выбранного фильтра
    func isSelected(at index: Int) -> Bool {
        //Кроме вариантов «Все трекеры» и «Трекеры на сегодня», поскольку это сброс фильтрации до стандартного состояния
        guard filters[index] != .allTrackers && filters[index] != .todayTrackers else { return false }
        
        return selectedIndex == index
    }
    
    //выбор фильтра
    func select(at index: Int) {
        selectedIndex = index
        onFilterChanged?()
    }
    
    //выбранный фильтр
    func selectedFilter() -> FiltersTracker? {
        guard let selectedIndex else { return nil }
        return filters[selectedIndex]
    }
}
