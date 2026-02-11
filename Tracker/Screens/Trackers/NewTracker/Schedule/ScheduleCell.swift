//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Максим Лозебной on 08.02.2026.
//
import UIKit

final class ScheduleCell: UITableViewCell {

    static let identifier = "ScheduleCell"

    var onSwitchChanged: ((Bool) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private let daySwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .ypBlue
        return sw
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(daySwitch)
        contentView.backgroundColor = Colors.bckgGrayDay
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        daySwitch.addTarget(self,
                            action: #selector(didTapSwitchChange),
                            for: .valueChanged)
    }

    func configure(title: String, isOn: Bool) {
        titleLabel.text = title
        daySwitch.isOn = isOn
    }

    @objc
    private func didTapSwitchChange() {
        onSwitchChanged?(daySwitch.isOn)
        print("Выбран день с помошью свича")
    }
}
