//
//  StatisticsView.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.01.2026.
//

import UIKit

final class StatisticsView: UIView {
    
    // MARK: - UI
    private lazy var nameStatsScreenLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.statsScreenName
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    private lazy var backStackView: UIStackView = setupBackgroundStack()
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = Colors.backgroundView
        addSubviews(
            tableView,
            nameStatsScreenLabel,
            backStackView
        )
        setupLayout()
        makeStatsTableView()
    }
    
    private func setupLayout() {
        [tableView, backStackView, nameStatsScreenLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameStatsScreenLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.nameTrScrLabelTop),
            nameStatsScreenLabel.widthAnchor.constraint(equalToConstant: Metrics.nameTrScrLabelW),
            nameStatsScreenLabel.heightAnchor.constraint(equalToConstant: Metrics.nameTrScrLabelH),
            nameStatsScreenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.l),
        ])
        
        NSLayoutConstraint.activate([
            backStackView.topAnchor.constraint(equalTo: topAnchor, constant: 375),
            backStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: nameStatsScreenLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupBackgroundStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let questionTitle = UILabel()
        questionTitle.text = L10n.statsScreenPlaceholderText
        questionTitle.textAlignment = .center
        questionTitle.textColor = Colors.textPrimary
        questionTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        let imageView = UIImageView(image: UIImage(named: "backgrStatsScreen"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        [imageView, questionTitle].forEach {
            stack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            questionTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
        
        return stack
    }
    
    private func makeStatsTableView() {
        tableView.backgroundColor = .clear
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 77, left: 0, bottom: 0, right: 0)
        tableView.layer.cornerRadius = 0
        tableView.layer.masksToBounds = false
        tableView.isScrollEnabled = true
                
        tableView.register(
            StatisticsCell.self,
            forCellReuseIdentifier: StatisticsCell.reuseIdentifier
        )
    }
}

//MARK: Ext View для работы в контроллере
extension StatisticsView {
    var statsTableView: UITableView {
        tableView
    }
    
    var placeholderLabelStack: UIStackView {
        backStackView
    }
}
