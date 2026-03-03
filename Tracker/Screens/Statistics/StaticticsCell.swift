//
//  StaticticsCell.swift
//  Tracker
//
//  Created by Максим Лозебной on 02.03.2026.
//

import UIKit

final class StatisticsCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: StatisticsCell.self)
    
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    private lazy var countLabel = UILabel()
    private lazy var nameStatisticsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth: CGFloat = 1
        
        gradientLayer.frame = contentView.bounds
        
        let insetRect = contentView.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: 15.5)
        shapeLayer.path = path.cgPath
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = Colors.backgroundView
        
        configureUI()
        setupLayout()
    }
    
    private func setupLayout() {
        [countLabel, nameStatisticsLabel].forEach {
            contentView.addSubviews($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            nameStatisticsLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            nameStatisticsLabel.trailingAnchor.constraint(equalTo: countLabel.trailingAnchor),
            nameStatisticsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func configureUI() {
        countLabel.textColor = Colors.textPrimary
        countLabel.font = .systemFont(ofSize: 34, weight: .bold)
        countLabel.textAlignment = .left
        
        nameStatisticsLabel.textColor = Colors.textPrimary
        nameStatisticsLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            Colors.borderRed.cgColor,
            Colors.borderGreen.cgColor,
            Colors.borderBlue.cgColor
        ]
        
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Colors.backgroundView.cgColor
        
        gradientLayer.mask = shapeLayer
        
        contentView.layer.addSublayer(gradientLayer)
    }
    
    func configureCell(countDays: String, statsTitle: String) {
        countLabel.text = countDays
        nameStatisticsLabel.text = statsTitle
    }
}
