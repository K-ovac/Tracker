//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 08.02.2026.
//
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(_ weekdays: Set<Weekday>)
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var selectedWeekdays: Set<Weekday> = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 75
        return tableView
    }()
    
    private let completeButton = makeBottomButton(
        title: "Готово",
        titleColor: .ypWhite,
        background: Colors.backgroundButton
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTable()
    }
    
    private func setupView() {
        navigationItem.title = "Расписание"
        view.backgroundColor = Colors.background
        
        view.addSubview(tableView)
        view.addSubview(completeButton)
        
        completeButton.addTarget(
            self,
            action: #selector(didTapComplete),
            for: .touchUpInside
        )
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.reloadData()
        tableView.register(ScheduleCell.self,
                           forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -16)
        ])
    }
    
    private static func makeBottomButton(
        title: String,
        titleColor: UIColor,
        background: UIColor
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = background
        button.layer.cornerRadius = Metrics.defCornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    
    @objc
    private func didTapComplete() {
        delegate?.didSelectSchedule(selectedWeekdays)
        dismiss(animated: true)
        print("Нажата кнопка Готово")
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.identifier,
            for: indexPath
        ) as? ScheduleCell else {
            return UITableViewCell()
        }
        
        let day = Weekday.allCases[indexPath.row]
        cell.configure(title: day.fullTitle,
                       isOn: selectedWeekdays.contains(day))
        
        cell.onSwitchChanged = { [weak self] isOn in
            guard let self else { return }
            
            if isOn {
                self.selectedWeekdays.insert(day)
            } else {
                self.selectedWeekdays.remove(day)
            }
        }
        
        return cell
    }
}
