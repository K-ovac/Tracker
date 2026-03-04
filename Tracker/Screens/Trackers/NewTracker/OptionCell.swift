//
//  OptionCell.swift
//  Tracker
//
//  Created by Максим Лозебной on 13.02.2026.
//

import UIKit

final class OptionCell: UICollectionViewCell {

    static let identifier = "OptionCell"
    
    // MARK: - UI
    private let emojiLabel = UILabel()
    private let colorLabel = UILabel()
    
    // MARK: - Init With Layout
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = true
        
        emojiLabel.font = .systemFont(ofSize: 32)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.layer.cornerRadius = 8
        colorLabel.layer.masksToBounds = true
        
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            colorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorLabel.heightAnchor.constraint(equalToConstant: 40),
            colorLabel.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Cells
    func configureEmoji(_ emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        
        contentView.layer.borderWidth = 0
        
        if isSelected {
            contentView.backgroundColor = Colors.backgroungEmojiLabelOptionCell
            contentView.layer.cornerRadius = 16
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.cornerRadius = 0
        }
        
        emojiLabel.isHidden = false
        colorLabel.isHidden = true
        
    }
    
    func configureColor(_ color: UIColor, isSelected: Bool) {
        contentView.backgroundColor = .clear
        
        colorLabel.backgroundColor = color
        
        if isSelected {
            contentView.layer.borderColor = color.cgColor
            contentView.layer.borderWidth = 3
            contentView.layer.cornerRadius = 8
        } else {
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
        }
        
        emojiLabel.isHidden = true
        colorLabel.isHidden = false
    }
}
