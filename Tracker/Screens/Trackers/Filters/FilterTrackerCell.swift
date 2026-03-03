//
//  FilterTrackerCell.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.02.2026.
//

import UIKit

final class FilterTrackerCell: UITableViewCell {
    //MARK: Cell Identifier
    static let reuseIndentifier = String(describing: FilterTrackerCell.self)
    
    //MARK: UI
    private lazy var filterTitleLabel = UILabel()
    private lazy var checkmarkImageView = UIImageView()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup View
    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = Colors.optionBackground
        setupLayout()
        configureUI()
    }
    
    //MARK: Layout
    private func setupLayout() {
        [filterTitleLabel, checkmarkImageView].forEach {
            contentView.addSubviews($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            filterTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.l),
            filterTitleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -1),
            filterTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metrics.t),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    //MARK: Configure UI
    private func configureUI() {
        filterTitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.isHidden = true
    }
    
    //MARK: Configure Cell
    func configureCell(title: String, isSelected: Bool) {
        filterTitleLabel.text = title
        
        //условие чекбокса выбранного фильтра
        if isSelected {
            checkmarkImageView.isHidden = false
            checkmarkImageView.tintColor = Colors.selectedItemTint
        } else {
            checkmarkImageView.isHidden = true
        }
    }
}
