//
//  OptionCategories.swift
//  Tracker
//
//  Created by Максим Лозебной on 13.02.2026.
//

import UIKit

final class OptionHeaderViewController: UICollectionReusableView {
    static let identifier = "OptionHeaderView"
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(categoryNameLabel)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title: String) {
        categoryNameLabel.text = title
    }
}
