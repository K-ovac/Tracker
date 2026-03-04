//
//  TrackerView.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.01.2026.
//

import UIKit

//MARK: TrackerViewDelegate
protocol TrackerViewDelegate: AnyObject {
    func didTapFiltersButton()
}

final class TrackerView: UIView {
    //MARK: Properties
    weak var delegate: TrackerViewDelegate?
    // MARK: - UI
    lazy var filtersButton = makeFiltersButton(
        title: L10n.filtersButton,
        tintColor: Colors.filtersButtonTint,
        bckgColor: Colors.filtersButtonBackground,
        titleSize: 17,
    )
    
    lazy var backStack: UIStackView = setupBackgroundStack()
    
    private lazy var trackerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 9
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 66, right: 0)
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
        backgroundColor = Colors.backgroundView
        addSubviews(
            
            trackerCollectionView,
            filtersButton,
            backStack,
        )
    }
    
    private func setupLayout() {
        [
            backStack,
            trackerCollectionView,
            filtersButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 220),
            backStack.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            trackerCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func makeFiltersButton(title: String, tintColor: UIColor, bckgColor: UIColor,titleSize: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = bckgColor
        button.tintColor = tintColor
        button.titleLabel?.font = .systemFont(ofSize: titleSize, weight: .regular)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = false
        button.isHidden = true
        
        return button
    }
    
    private func setupBackgroundStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let questionTitle = UILabel()
        questionTitle.text = L10n.trackersScreenPlaceholderText
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
    
    func updatePlaceholder(image: UIImage, description: String) {
        guard let imageView = backStack.arrangedSubviews.first as? UIImageView,
              let label = backStack.arrangedSubviews.last as? UILabel else { return }
        
        imageView.image = image
        label.text = description
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

extension TrackerView {
    var collectionView: UICollectionView {
        trackerCollectionView
    }
}

// MARK: - Ext UIView
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }
}
