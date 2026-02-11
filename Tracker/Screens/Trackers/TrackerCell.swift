//
//  TrackerCell.swift
//  Tracker
//
//  Created by Максим Лозебной on 07.02.2026.
//
import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTrackerCellButtonTapped(_ cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    static let identifier: String = "TrackerCell"
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - UI
    
    private var trackerId: UUID?
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Metrics.defCornerRadius
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.backgroundColor = Colors.backEmoji
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Metrics.trackCellPrimTextH, weight: .medium)
        label.textColor = .ypWhite
        label.numberOfLines = 2
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.textPrimary
        return label
    }()
    
    private var endTrackerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.tintColor = .ypWhite
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        contentView.layer.cornerRadius = Metrics.defCornerRadius
        contentView.layer.masksToBounds = true
        
        [colorView, emojiLabel, taskLabel, daysLabel, endTrackerButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupLayout() {
        [colorView, emojiLabel, taskLabel, daysLabel, endTrackerButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            taskLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            taskLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            taskLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            endTrackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            endTrackerButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            endTrackerButton.widthAnchor.constraint(equalToConstant: 34),
            endTrackerButton.heightAnchor.constraint(equalToConstant: 34)
            
        ])
    }
    
    private func daysTitle(for count: Int) -> String {
        switch count {
        case 1:
            return "1 день"
        case 2...4:
            return "\(count) дня"
        default:
            return "\(count) дней"
        }
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        endTrackerButton.addTarget(
            self,
            action: #selector(didTapEndTracker),
            for: .touchUpInside
        )
    }
    
    func configure(with tracker: Tracker, completedDates: [Date], selectedDate: Date) {
        self.trackerId = tracker.id
        colorView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        taskLabel.text = tracker.name
        
        let isCompletedToday = completedDates.contains { Calendar.current.isDate($0, inSameDayAs: selectedDate) }
        
        let buttonImage = isCompletedToday ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        endTrackerButton.setImage(buttonImage, for: .normal)
        endTrackerButton.backgroundColor = isCompletedToday ? tracker.color.withAlphaComponent(0.3) : tracker.color
        
        let daysCount = completedDates
            .filter { $0 >= tracker.dayCreatedTracker && $0 <= selectedDate }
            .count
        daysLabel.text = daysTitle(for: daysCount)
    }
    
    @objc
    private func didTapEndTracker() {
        delegate?.didTrackerCellButtonTapped(self)
    }
}
