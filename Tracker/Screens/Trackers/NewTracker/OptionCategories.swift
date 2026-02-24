//
//  OptionCategories.swift
//  Tracker
//
//  Created by Максим Лозебной on 13.02.2026.
//

import UIKit

final class OptionHeaderViewController: UICollectionReusableView {
    //MARK: Properties
    static let identifier = "OptionHeaderView"
    
    //MARK: UI
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    //MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    private func setupLayout() {
        addSubview(categoryNameLabel)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(title: String) {
        categoryNameLabel.text = title
    }
}
