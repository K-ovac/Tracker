//
//  TrackerView.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.01.2026.
//

import UIKit

final class TrackerView: UIView {
    
    weak var delegate: TrackerViewDelegate?
    
    var collectionView: UICollectionView {
        trackerCollectionView
    }
    
    // MARK: - UI
    private let filtersButton = TrackerView.makeFiltersButton(
        title: "Фильтры",
        tintColor: .ypWhite,
        bckgColor: .ypBlue,
        titleSize: 17,
    )
    
    private let nameTrackerScreenLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let searchField: UISearchBar = {
        let searchField = UISearchBar()
        searchField.placeholder = "Поиск"
        searchField.backgroundImage = UIImage()
        return searchField
    }()
    
    let backStack: UIStackView = TrackerView.setupBackgroundStack()
    
    private let trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 9
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.background
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupActions()
        trackerCollectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = Colors.background
        addSubviews(
            
            trackerCollectionView,
            nameTrackerScreenLabel,
            searchField,
            filtersButton,
            backStack
        )
    }
    
    private func setupLayout() {
        [backStack, trackerCollectionView, nameTrackerScreenLabel, searchField, filtersButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameTrackerScreenLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.nameTrScrLabelTop),
            nameTrackerScreenLabel.widthAnchor.constraint(equalToConstant: Metrics.nameTrScrLabelW),
            nameTrackerScreenLabel.heightAnchor.constraint(equalToConstant: Metrics.nameTrScrLabelH),
            nameTrackerScreenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.l),
            
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.searchFieldtop),
            searchField.heightAnchor.constraint(equalToConstant: Metrics.searchFieldH),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metrics.t),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.l),
            
            backStack.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 230),
            backStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            trackerCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.l),
            trackerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metrics.t),
            trackerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private static func makeFiltersButton(title: String, tintColor: UIColor, bckgColor: UIColor,titleSize: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = bckgColor
        button.tintColor = tintColor
        button.titleLabel?.font = .systemFont(ofSize: titleSize, weight: .regular)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        return button
    }
    
    private static func setupBackgroundStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let questionTitle = UILabel()
        questionTitle.text = "Что будем отслеживать?"
        questionTitle.textAlignment = .center
        questionTitle.textColor = Colors.textPrimary
        questionTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        let imageView = UIImageView(image: UIImage(named: "backgroundTrackerScreen"))
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
    
    // MARK: - Setup Actions
    private func setupActions() {
        filtersButton.addTarget(self,
                                action: #selector(didTapFilters),
                                for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapFilters() {
        delegate?.didTapFiltersButton()
    }
}

// MARK: - Ext UIView
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }
}
