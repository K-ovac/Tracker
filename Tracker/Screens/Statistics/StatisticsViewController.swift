//
//  Statistics.swift
//  Tracker
//
//  Created by Максим Лозебной on 27.01.2026.
//

import UIKit

final class StatisticsViewController: UIViewController {
    //MARK: Properties
    private let defaultService = DefaultsService()          //UserDefaults
    
    private let trackerRecordStore = TrackerRecordStore()   //record store
    private let trackerStore = TrackerStore()               //tracker store
    
    private var statsResults: [StatisticModel] = []
    
    //MARK: UI
    private lazy var statsView = StatisticsView()
    
    //MARK: Lifecycle
    override func loadView() {
        view = statsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatsTableViewDataAndDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateStatistics()
    }
    
    //MARK: Factory Methods
    private func configureStatsTableViewDataAndDelegate() {
        statsView.statsTableView.dataSource = self
        
        statsView.statsTableView.sectionFooterHeight = 12
        statsView.statsTableView.sectionHeaderHeight = 0
    }
    
    private func calculateStatistics() {
        //метод вычисления статистики
        let completed = trackerRecordStore.fetchCompletedTrackers()
        let calendar = Calendar.current
        //сохранение значения количества зачершенных трекеров
        defaultService.trackersCompleted = completed.count
        
        let groupedByDate = Dictionary(grouping: completed) {
            calendar.startOfDay(for: $0.date)
        }
        //сохранение значения авг. значения относительно всех трекеров
        defaultService.avgScore = groupedByDate.isEmpty ? 0 : completed.count / groupedByDate.count
        
        let recordsByTracker = trackerRecordStore.fetchAllRecordsGroupedByTracker()
        var maxStreak = 0
        
        for (_, dates) in recordsByTracker {
            let sortedDates = Set(dates).sorted()
            var currentStreak = 1
            
            for i in 1..<sortedDates.count {
                let diff = calendar.dateComponents([.day], from: sortedDates[i - 1], to: sortedDates[i]).day ?? 0
                if diff == 1 {
                    currentStreak += 1
                    maxStreak = max(maxStreak, currentStreak)
                } else {
                    currentStreak = 1
                }
            }
            
            if sortedDates.count == 1 {
                maxStreak = max(maxStreak, 1)
            }
        }
        //сохранение значения по стрику дней
        defaultService.bestPeriod = maxStreak
        
        do {
            let allCategories = try trackerStore.fetchTrackersByCategory()
            let allTrackers = allCategories.flatMap { $0.trackers }
            var perfectDays = 0
            
            for (day, records) in groupedByDate {
                let weekday = Weekday.weekdayFrom(date: day)
                
                let plannedTrackers = allTrackers.filter { tracker in
                    tracker.schedule.contains(weekday) &&
                    calendar.startOfDay(for: tracker.dayCreatedTracker) <= day
                }
                
                guard !plannedTrackers.isEmpty else { continue }
                
                let completedIds = Set(records.map { $0.trackerId })
                let allCompleted = plannedTrackers.allSatisfy { completedIds.contains($0.id) }
                
                if allCompleted { perfectDays += 1 }
            }
            
            //сохранение кол-ва дней, если выполнены все трекеры за день
            defaultService.perfectDays = perfectDays
        } catch {
            print("Ошибка при подсчёте идеальных дней:", error)
        }
        
        statsResults = Statistics.allCases.map { stat in
            let count: Int
            switch stat {
            case .bestPeriod:        count = defaultService.bestPeriod
            case .perfectDays:       count = defaultService.perfectDays
            case .trackersCompleted: count = defaultService.trackersCompleted
            case .avgScore:          count = defaultService.avgScore
            }
            return StatisticModel(count: count, title: stat.statsTitle)
        }
        
        let hasData = statsResults.contains { $0.count > 0 }
        statsView.placeholderLabelStack.isHidden = hasData
        statsView.statsTableView.isHidden = !hasData
        statsView.statsTableView.reloadData()
    }
}

extension StatisticsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Statistics.allCases.count
    }
    
    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.reuseIdentifier, for: indexPath) as? StatisticsCell else { return UITableViewCell() }
        
        let stats = statsResults[indexPath.section]
        cell.configureCell(
            countDays: String(stats.count),
            statsTitle: stats.title
        )
        
        return cell
    }
}
