//
//  CategoryCell.swift
//  Tracker
//
//  Created by Максим Лозебной on 12.02.2026.
//
import UIKit

final class CategoryCell: UITableViewCell {
    //MARK: - Properties
    static let identifier: String = "CategoryCell"
    
    //MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    private let checkmark: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        imageView.tintColor = .ypGray
        
        return imageView
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupView
    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = .ypGrayOp30
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmark)
    }
    
    private func setupLayout() {
        [
            titleLabel, checkmark
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.l),
            titleLabel.trailingAnchor.constraint(equalTo: checkmark.leadingAnchor, constant: -1),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metrics.t),
            checkmark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    //MARK: - Factory Methods
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            checkmark.tintColor = .ypBlue
        } else {
            checkmark.tintColor = .ypGray
        }
    }
}
