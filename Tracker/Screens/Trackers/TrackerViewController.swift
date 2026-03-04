//
//  ViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 20.01.2026.
//

import Foundation
import UIKit
import AppMetricaCore

final class TrackerViewController: UIViewController {
    //MARK: CoreData Stores
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    //MARK: Properties
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    //MARK: UI
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    private let searchController = UISearchController(searchResultsController: nil)
    private let trackerView = TrackerView()
    
    private var trackerCategories: [TrackerCategory] = [TrackerCategory(title: "Важное",
                                                                        trackers: [])]
    private var filteredCategories: [TrackerCategory] = []
    private var endedTrackers: [TrackerRecord] = []
    private var filteredTrackers: [Tracker] = []
    private var selectedFilter: FiltersTracker = .allTrackers
    private var searchText: String = ""
    
    // MARK: Lifecycle
    override func loadView() {
        view = trackerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAllData()
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        setupSearchController()
        setupNavigationBar()
        trackerView.delegate = self
        trackerView.collectionView.dataSource = self
        trackerView.collectionView.delegate = self
        
        trackerView.collectionView.register(
            TrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderView.identifier
        )
        
        loadTrackers()
        loadRecords()
        
        AnalyticsService.shared.report(event: "open", params: [
            "screen": "Main"
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            AnalyticsService.shared.report(event: "close", params: [
                "screen": "Main"
            ])
        }
    }
    
    // MARK: Setup
    private func setupNavigationBar() {
        navigationItem.title = L10n.trackersScreenName
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let addButtonImage = UIImage(named: "plus")
        let addTrackerButton = UIBarButtonItem(
            image: addButtonImage,
            style: .plain,
            target: self,
            action: #selector(didTapAddTracker)
        )
        addTrackerButton.tintColor = Colors.buttonBackground
        navigationItem.leftBarButtonItem = addTrackerButton
        
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged(_:)),
                             for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = L10n.searchFieldPlaceholder
        searchController.hidesNavigationBarDuringPresentation = false
        
    }
    
    // MARK: Func
    private func placeholderAndFiltersButtonVisibility() {
        let isEmpty = filteredCategories.isEmpty
        trackerView.backStack.isHidden = !isEmpty
        trackerView.filtersButton.isHidden = isEmpty
        
        if isEmpty {
            let isSearchActive = !searchText.isEmpty
            let isFilterActive = selectedFilter == .completed || selectedFilter == .notCompleted
            
            if isFilterActive || isSearchActive {
                trackerView.updatePlaceholder(
                    image: UIImage(named: "notFoundPlaceholder") ?? UIImage(),
                    description: L10n.trackersScreenPlaceholderTextForNotFound
                )
            } else {
                trackerView.updatePlaceholder(
                    image: UIImage(named: "backgroundTrackerScreen") ?? UIImage(),
                    description: L10n.trackersScreenPlaceholderText
                )
            }
        }
    }
    
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekday = Weekday.weekdayFrom(date: date)
        
        var result: [TrackerCategory] = []
        
        for category in trackerCategories {
            let filteredTrackers = category.trackers.filter { tracker in
                let isCorrectDay = tracker.schedule.contains(weekday)
                let isAfterCreationDate = calendar.startOfDay(for: date) >= calendar.startOfDay(for: tracker.dayCreatedTracker)
                guard isCorrectDay && isAfterCreationDate else { return false }
                
                if !searchText.isEmpty {
                    guard tracker.name.lowercased().contains(searchText.lowercased()) else { return false }
                }
                
                let completedDates = endedTrackers
                    .filter { $0.trackerId == tracker.id }
                    .map { calendar.startOfDay(for: $0.date) }
                let isCompleted = completedDates.contains(calendar.startOfDay(for: date))
                
                switch selectedFilter {
                case .allTrackers, .todayTrackers:
                    return true
                case .completed:
                    return isCompleted
                case .notCompleted:
                    return !isCompleted
                }
            }
            
            if !filteredTrackers.isEmpty {
                result.append(TrackerCategory(title: category.title, trackers: filteredTrackers))
            }
        }
        
        filteredCategories = result
        endedTrackers = trackerRecordStore.fetchCompletedTrackers()
        
        trackerView.collectionView.reloadData()
        placeholderAndFiltersButtonVisibility()
    }
    
    private func loadTrackers() {
        do {
            let categories = try trackerStore.fetchTrackersByCategory()
            self.trackerCategories = categories
            filterTrackers(for: datePicker.date)
        } catch {
            print("Ошибка при загрузке трекеров:", error)
        }
    }
    
    private func loadRecords() {
        endedTrackers = trackerRecordStore.fetchCompletedTrackers()
        filterTrackers(for: datePicker.date)
    }
    
    private func deleteAllData() {
        do {
            try trackerStore.deleteAllTrackers()
            try trackerRecordStore.deleteAllRecords()
            try trackerCategoryStore.deleteAllCategories()
            loadTrackers()
        } catch {
            print("Ошибка при очистке базы:", error)
        }
    }
    
    private func showDeleteAlert(for tracker: Tracker) {
        let alert = UIAlertController(
            title: L10n.deleteAlertTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: L10n.deleteActionTitle, style: .destructive) { [weak self] _ in
            do {
                try self?.trackerStore.deleteTracker(id: tracker.id)
            } catch {
                print("Ошибка удаления:", error)
            }
        }
        
        let cancelAction = UIAlertAction(title: L10n.cancelDeleteActionTitle, style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func editTracker(_ tracker: Tracker) {
        let editVC = EditTrackerViewController()
        editVC.delegate = self
        
        let category = trackerCategories
            .first(where: { $0.trackers.contains(where: { $0.id == tracker.id }) })?.title ?? ""
        
        editVC.setupWithTracker(tracker, category: category)
        
        present(UINavigationController(rootViewController: editVC), animated: true)
    }
    
    // MARK: Actions NavBar
    @objc
    private func didTapAddTracker() {
        print("Нажата кнопка создания трекера")
        
        AnalyticsService.shared.report(event: "click", params: [
            "screen": "Main",
            "item": "add_track"
        ])
        
        let newTrackerVC = NewTrackerViewController()
        newTrackerVC.delegate = self
        let navigationController = UINavigationController(rootViewController: newTrackerVC)
        present(navigationController, animated: true)
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = TrackerViewController.dateFormatter.string(from: selectedDate)
        print("Выбрана дата: \(formattedDate)")
        
        filterTrackers(for: selectedDate)
    }
}

// MARK: Ext TrackerViewDelegate
extension TrackerViewController: TrackerViewDelegate {
    
    func didTapFiltersButton() {
        print("Нажата кнопка фильтров")
        
        let filtersVC = FiltersTrackerViewController(currentFilter: selectedFilter)
        filtersVC.delegate = self
        present(UINavigationController(rootViewController: filtersVC), animated: true)
        
        AnalyticsService.shared.report(event: "click", params: [
            "screen": "Main",
            "item": "filter"
        ])
    }
}

// MARK: Ext Collection DataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier,
                                                            for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let completedDates = endedTrackers.filter { $0.trackerId == tracker.id }.map { $0.date }
        cell.configure(with: tracker, completedDates: completedDates, selectedDate: datePicker.date)
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderView.identifier,
            for: indexPath
        ) as? TrackerHeaderView else { return UICollectionReusableView() }
        
        let category = filteredCategories[indexPath.section]
        header.configure(title: category.title)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 46)
    }
}

// MARK: Ext Collection FlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
    }
}

// MARK: Ext TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func didTapEdit(trackerId: UUID) {
        guard let tracker = filteredCategories
            .flatMap({ $0.trackers })
            .first(where: { $0.id == trackerId }) else { return }
        
        editTracker(tracker)
        
        AnalyticsService.shared.report(event: "click", params: [
            "screen": "Main",
            "item": "edit"
        ])
    }
    
    func didTapDelete(trackerId: UUID) {
        guard let tracker = filteredCategories
            .flatMap({ $0.trackers })
            .first(where: { $0.id == trackerId }) else { return }
        
        showDeleteAlert(for: tracker)
        
        AnalyticsService.shared.report(event: "click", params: [
            "screen": "Main",
            "item": "delete"
        ])
    }
    
    func didTrackerCellButtonTapped(_ cell: TrackerCell) {
        print("Нажата кнопка отметки трекера")
        
        guard let indexPath = trackerView.collectionView.indexPath(for: cell) else { return }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let selectedDate = datePicker.date
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: Date())
        let dayToMark = calendar.startOfDay(for: selectedDate)
        guard dayToMark <= today else { return }
        do {
            try trackerRecordStore.toggleRecord(for: tracker.id, on: selectedDate)
            endedTrackers = trackerRecordStore.fetchCompletedTrackers()
            updateTrackerCell(at: indexPath)
        } catch {
            print("Ошибка при отметке трекера:", error)
        }
        
        AnalyticsService.shared.report(event: "click", params: [
            "screen": "Main",
            "item": "track"
        ])
    }
    
    private func updateTrackerCell(at indexPath: IndexPath) {
        guard let cell = trackerView.collectionView.cellForItem(at: indexPath) as? TrackerCell else { return }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let selectedDate = datePicker.date
        
        let completedDates = endedTrackers
            .filter { $0.trackerId == tracker.id }
            .map { $0.date }
        
        cell.configure(with: tracker, completedDates: completedDates, selectedDate: selectedDate)
    }
}

// MARK: Ext NewTrackerViewControllerDelegate
extension TrackerViewController: NewTrackerViewControllerDelegate {
    func didTappedUpdateTracker(_ tracker: Tracker, categoryTitle: String) {
        do {
            try trackerStore.updateTracker(tracker: tracker, categoryTitle: categoryTitle)
        } catch {
            print("Ошибка обновления трекера:", error)
        }
    }
    
    func didTappedCreateNewTracker(_ tracker: Tracker, categoryTitle: String) {
        do {
            try trackerStore.createTracker(tracker: tracker, categoryTitle: categoryTitle)
        } catch {
            print("Ошибка создания нового трекера:", error)
        }
    }
}

//MARK: Ext TrackerViewController: TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func didUpdateTrackers() {
        loadTrackers()
    }
}

//MARK: Ext TrackerViewController: TrackerRecordStoreDelegate
extension TrackerViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords() {
        loadRecords()
    }
}

//MARK: Ext TrackerViewController: FiltersTrackerViewControllerDelegate
extension TrackerViewController: FiltersTrackerViewControllerDelegate {
    func didSelectFilter(_ filterName: FiltersTracker) {
        selectedFilter = filterName
        
        if filterName == .todayTrackers {
            datePicker.setDate(Date(), animated: true)
        }
        
        filterTrackers(for: datePicker.date)
        
        print("Выбран фильтр:", filterName.filterTitle)
        dismiss(animated: true)
    }
}

//MARK: Ext TrackerViewController: UISearchTextFieldDelegate    textFieldShouldReturn
extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
        filterTrackers(for: datePicker.date)
    }
}
