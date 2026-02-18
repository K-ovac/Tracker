//
//  ViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 20.01.2026.
//

import UIKit

final class TrackerViewController: UIViewController {
    //MARK: Properties
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private let trackerView = TrackerView()
    private var trackerCategories: [TrackerCategory] = [TrackerCategory(title: "Важное",
                                                                        trackers: [])]
    private var filteredCategories: [TrackerCategory] = []
    private var endedTrackers: [TrackerRecord] = []
    private var filteredTrackers: [Tracker] = []
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    // MARK: Lifecycle
    override func loadView() {
        view = trackerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
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
    }
    
    // MARK: Setup
    private func setupNavigationBar() {
        let addTrackerButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddTracker)
        )
        addTrackerButton.tintColor = Colors.backgroundButton
        addTrackerButton.image = UIImage(named: "addButton")
        navigationItem.leftBarButtonItem = addTrackerButton
        
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged(_:)),
                             for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: Func
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let calendarWeekday = calendar.component(.weekday, from: date)
        
        let mapping: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        let weekday = mapping[calendarWeekday - 1]
        
        var result: [TrackerCategory] = []
        
        for category in trackerCategories {
            let filteredTrackers = category.trackers.filter { tracker in
                let isCorrectDay = tracker.schedule.contains(weekday)
                let isAfterCreationDate = calendar.startOfDay(for: date) >= calendar.startOfDay(for: tracker.dayCreatedTracker)
                return isCorrectDay && isAfterCreationDate
            }
            
            if !filteredTrackers.isEmpty {
                result.append(TrackerCategory(title: category.title, trackers: filteredTrackers))
            }
        }
        
        filteredCategories = result
        endedTrackers = trackerRecordStore.fetchCompletedTrackers()
        
        trackerView.collectionView.reloadData()
        trackerView.backStack.isHidden = !filteredCategories.isEmpty
        print("Отфильтрованные трекеры:", filteredTrackers.map { $0.name })
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
    
    // MARK: Actions NavBar
    @objc
    private func didTapAddTracker() {
        print("Нажата кнопка создания трекера")
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
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderView.identifier,
            for: indexPath
        ) as! TrackerHeaderView
        
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
        UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}

// MARK: Ext TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func didTrackerCellButtonTapped(_ cell: TrackerCell) {
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
    func didTappedCreateNewTracker(_ tracker: Tracker, categoryTitle: String) {
        do {
            try trackerStore.createTracker(tracker: tracker, categoryTitle: categoryTitle)
        } catch {
            print("Ошибка создания нового трекера:", error)
        }
    }
}

extension TrackerViewController: TrackerStoreDelegate {
    func didUpdateTrackers() {
        loadTrackers()
    }
}

extension TrackerViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords() {
        loadRecords()
    }
}
