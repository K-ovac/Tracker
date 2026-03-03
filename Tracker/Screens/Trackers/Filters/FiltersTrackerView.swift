//
//  FiltersTrackerView.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.02.2026.
//

import UIKit

final class FiltersTrackerView: UIView {
    //MARK: UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup View
    private func setupView() {
        backgroundColor = Colors.backgroundView
        
        [tableView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        makeFiltersTableView()
    }
    
    //MARK: Настройка таблицы
    private func makeFiltersTableView() {
        tableView.backgroundColor = .clear
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.reloadData()
        
        tableView.register(
            FilterTrackerCell.self,
            forCellReuseIdentifier: FilterTrackerCell.reuseIndentifier
        )
    }
}

//MARK: Расширение для использования таблицы в контроллере
extension FiltersTrackerView {
    var filtersTableView: UITableView {
        tableView
    }
}
