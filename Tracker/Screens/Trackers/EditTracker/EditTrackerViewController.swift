//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 01.03.2026.
//

import UIKit

//MARK: Контроллер экрана редактирования, наследованный от NewTrackerViewController, тк они идентичны. ну почти
final class EditTrackerViewController: NewTrackerViewController {
    //MARK: Properties
    private let recordStore = TrackerRecordStore()
    private var currentTracker: Tracker?
    private var currentCategoryTitle: String?
    
    //MARK: UI
    private lazy var currentRecordDaysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = Colors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    //переиспользование кнопки создания трекера для изменения ее метода
    override func didTapCreate() {
        saveTracker()
    }
    
    //MARK: Factory Methods
    private func updateView() {
        //обновление вью элементов для нового экрана
        navigationItem.title = L10n.editScreenName
        setCreateButtonTitle(L10n.saveButtonTitle)
        
        [currentRecordDaysLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        insertIntoContentStack(currentRecordDaysLabel, at: 0, spacing: 40)
    }
    
    
    func setupWithTracker(_ tracker: Tracker, category: String) {
        //сет значений редактируемого трекера
        self.currentTracker = tracker
        self.currentCategoryTitle = category
        
        configureForEditing(tracker: tracker, category: category)
        currentRecordDaysLabel.text = L10n.daysTitle(for: trackerRecordCount(for: tracker))
        
    }
    
    private func saveTracker() {
        //сохранение трекера с измененными атрибутами
        guard
            let tracker = currentTracker,
            let name = currentName,
            let emoji = currentEmoji,
            let color = currentColor,
            let schedule = currentSchedule,
            let category = currentCategory
        else {
            return
        }
        
        let updatedTracker = Tracker(
            id: tracker.id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            dayCreatedTracker: tracker.dayCreatedTracker
        )
        
        delegate?.didTappedUpdateTracker(updatedTracker, categoryTitle: category)
        dismiss(animated: true)
    }
    
    private func trackerRecordCount(for tracker: Tracker) -> Int {
        //метод, определяющий количество дней трекера
        recordStore.completedDaysCount(for: tracker.id)
    }
}
