//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 08.02.2026.
//

import UIKit

//MARK: NewTrackerViewControllerDelegate
protocol NewTrackerViewControllerDelegate: AnyObject {
    func didTappedCreateNewTracker(_ tracker: Tracker, categoryTitle: String)
    //метод для кнопки изменения трекера
    func didTappedUpdateTracker(_ tracker: Tracker, categoryTitle: String)
}
//MARK: Класс, от которого наследуется класс экрана редактирования
class NewTrackerViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private var selectedWeekdays: Set<Weekday> = []
    private var selectedCategoryName: String = "Радостные мелочи"
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    // MARK: - Scroll
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI
    private var collectionHeight: NSLayoutConstraint?
    
    private let nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = L10n.nameTrackerTextFieldPlaceholder
        textField.backgroundColor = Colors.nameTextFieldBackground
        textField.layer.cornerRadius = Metrics.defCornerRadius
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        
        let clearButton = UIButton(type: .system)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = Colors.clearButtonTextFieldBackground
        clearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        clearButton.addTarget(nil, action: #selector(didTapClearText), for: .touchUpInside)
        
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 24))
        rightContainer.addSubview(clearButton)
        clearButton.center = CGPoint(x: rightContainer.frame.width / 2 - 6, y: rightContainer.frame.height / 2)
        
        textField.rightView = rightContainer
        textField.rightViewMode = .never
        
        return textField
    }()
    
    private let nameLimitLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.nameLimitLabel
        label.font = .systemFont(ofSize: 17)
        label.textColor = Colors.textLimitLabel
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 33).isActive = true
        return label
    }()
    
    private let categoryButton = NewTrackerViewController.setupOptionButton(title: L10n.categotyButton)
    private let scheduleButton = NewTrackerViewController.setupOptionButton(title: L10n.scheduleButton)
    
    private let scheduleSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = Colors.optionSubtitleLabelText
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    private let categorySubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = Colors.optionSubtitleLabelText
        label.numberOfLines = 1
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.optionSeparatorView
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    private let separatorContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let cancelButton = NewTrackerViewController.makeBottomButton(
        title: L10n.cancelButton,
        titleColor: Colors.cancelButtonText,
        background: .clear,
        border: true
    )
    
    private let createButton = NewTrackerViewController.makeBottomButton(
        title: L10n.createButton,
        titleColor: Colors.buttonText,
        background: Colors.buttonBackground,
        border: false
    )
    
    private let optionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.alwaysBounceVertical = false
        
        return collectionView
    }()
    
    // MARK: - Stacks
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private lazy var fieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTrackerTextField, nameLimitLabel])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let optionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = Colors.optionBackground
        stack.layer.cornerRadius = Metrics.defCornerRadius
        stack.layer.masksToBounds = true
        return stack
    }()
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupActions()
        setupKeyboard()
        
        nameTrackerTextField.delegate = self
        nameTrackerTextField.becomeFirstResponder()
        
        optionCollectionView.dataSource = self
        optionCollectionView.delegate = self
        
        optionCollectionView.register(OptionCell.self,
                                      forCellWithReuseIdentifier: OptionCell.identifier)
        optionCollectionView.register(OptionHeaderViewController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OptionHeaderViewController.identifier)
        
        updateCreateButtonState()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionHeight?.constant = optionCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    // MARK: - Setup
    private func setupView() {
        navigationItem.title = L10n.newTrackerNavigationTitle
        view.backgroundColor = Colors.backgroundView
        
        scheduleButton.addSubview(scheduleSubtitleLabel)
        categoryButton.addSubview(categorySubtitleLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(fieldStack)
        contentStackView.addArrangedSubview(optionsStackView)
        contentStackView.addArrangedSubview(optionCollectionView)
        contentStackView.setCustomSpacing(24, after: fieldStack)
        
        optionsStackView.addArrangedSubview(categoryButton)
        
        separatorContainer.addSubview(separator)
        
        optionsStackView.addArrangedSubview(separatorContainer)
        optionsStackView.addArrangedSubview(scheduleButton)
        
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
    }
    
    private func setupLayout() {
        [scrollView, contentView, contentStackView, buttonsStackView, scheduleSubtitleLabel, separator, separatorContainer, fieldStack, categorySubtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
        ])
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.l),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metrics.t),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            separator.leadingAnchor.constraint(equalTo: separatorContainer.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: separatorContainer.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor),
            separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separatorContainer.heightAnchor.constraint(equalToConstant: 1),
        ])
        NSLayoutConstraint.activate([
            scheduleSubtitleLabel.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
            scheduleSubtitleLabel.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            scheduleSubtitleLabel.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -14),
        ])
        NSLayoutConstraint.activate([
            categorySubtitleLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            categorySubtitleLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            categorySubtitleLabel.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -14),
        ])
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.l),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metrics.t),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: Metrics.heightButton),
        ])
        
        collectionHeight = optionCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionHeight?.isActive = true
    }
    
    // MARK: - Factory methods
    private static func setupOptionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = Colors.textPrimary
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let arrowImage = UIImage(systemName: "chevron.right")
        let arrowView = UIImageView(image: arrowImage)
        arrowView.tintColor = .gray
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            arrowView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16)
        ])
        
        return button
    }
    
    private static func makeBottomButton(
        title: String,
        titleColor: UIColor,
        background: UIColor,
        border: Bool
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(Colors.inactiveButtonText, for: .disabled)
        button.backgroundColor = background
        button.layer.cornerRadius = Metrics.defCornerRadius
        button.layer.masksToBounds = true
        if border {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.ypRed.cgColor
        }
        return button
    }
    
    // MARK: - Logic
    private func updateScheduleButtonTitle() {
        guard !selectedWeekdays.isEmpty else {
            scheduleSubtitleLabel.isHidden = true
            scheduleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            return
        }
        
        let text = selectedWeekdays.count == 7
        ? L10n.subLabelAllDay
        : selectedWeekdays.sorted { $0.rawValue < $1.rawValue }
            .map { $0.shortTitle }
            .joined(separator: ", ")
        
        scheduleSubtitleLabel.text = text
        scheduleSubtitleLabel.isHidden = false
        scheduleButton.contentEdgeInsets = UIEdgeInsets(top: -12, left: 16, bottom: 12, right: 16)
    }
    
    private func updateCategoryButtonTitle() {
        categorySubtitleLabel.text = selectedCategoryName
        categorySubtitleLabel.isHidden = false
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: -12, left: 16, bottom: 12, right: 16)
    }
    
    private func updateCreateButtonState() {
        let nameValid = !(nameTrackerTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let enabled = nameValid && !selectedWeekdays.isEmpty && (selectedColor != nil) && (selectedColor != nil)
        createButton.isEnabled = enabled
        createButton.backgroundColor = enabled ? Colors.buttonBackground : Colors.inactiveButtonBackground
    }
    
    private func hideLimitLabel() {
        let showLimit = (nameTrackerTextField.text?.count ?? 0) > 38
        nameLimitLabel.isHidden = !showLimit
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(didTapSchedule), for: .touchUpInside)
        nameTrackerTextField.addTarget(self, action: #selector(didSetNameTracker), for: .editingChanged)
        categoryButton.addTarget(self, action: #selector(didTapCategory), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapCancel() {
        print("Нажата кнопка отмены")
        dismiss(animated: true)
    }
    
    @objc func didTapCreate() {
        print("Нажата кнопка создать")
        guard let name = nameTrackerTextField.text,
              let emoji = selectedEmoji,
              let color = selectedColor else { return }
        let tracker = Tracker(id: UUID(),
                              name: name,
                              color: color,
                              emoji: emoji,
                              schedule: selectedWeekdays, dayCreatedTracker: Date())
        
        delegate?.didTappedCreateNewTracker(tracker, categoryTitle: selectedCategoryName)
        dismiss(animated: true)
    }
    
    @objc private func didTapSchedule() {
        print("Нажата кнопка расписания")
        let vc = ScheduleViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func didSetNameTracker() {
        updateCreateButtonState()
        let hasText = !(nameTrackerTextField.text?.isEmpty ?? true)
        nameTrackerTextField.rightViewMode = hasText ? .always : .never
        hideLimitLabel()
        print("В поле ввода введен символ")
    }
    
    @objc private func didTapClearText() {
        hideLimitLabel()
        nameTrackerTextField.text = ""
        nameTrackerTextField.rightViewMode = .never
        updateCreateButtonState()
        print("Поле названия трекера очищено")
    }
    
    @objc private func didTapCategory() {
        print("Нажата кнопка Категория")
        let vc = CategoryViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

// MARK: - Ext ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ weekdays: Set<Weekday>) {
        selectedWeekdays = weekdays
        print("Выбраны дни - \(selectedWeekdays.count): \(selectedWeekdays)")
        updateScheduleButtonTitle()
        updateCreateButtonState()
    }
}

// MARK: - Ext UITextFieldDelegate
extension NewTrackerViewController: CategoryViewControllerDelegate {
    func didSelectCategory(_ categoryName: String) {
        selectedCategoryName = categoryName
        updateCategoryButtonTitle()
        updateCreateButtonState()
        dismiss(animated: true)
    }
}

// MARK: - Ext UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text,
              let range = Range(range, in: text) else { return true }
        
        let updated = text.replacingCharacters(in: range, with: string)
        let valid = updated.count <= 38
        nameLimitLabel.isHidden = valid
        return valid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Keyboard Scroll
extension NewTrackerViewController {
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height + 16
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

// MARK: Ext UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = TrackerSection(rawValue: section) else { return 0 }
        return section.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell else { return UICollectionViewCell() }
        
        guard let sectionType = TrackerSection(rawValue: indexPath.section) else { return cell }
        
        switch sectionType {
        case .emojis:
            let emoji = TrackerEmojis.emojis[indexPath.row]
            let isSelected = emoji == selectedEmoji
            
            cell.configureEmoji(emoji, isSelected: isSelected)
        case .colors:
            let colorItem = TrackerColors.allCases[indexPath.row]
            let color = colorItem.uiColor
            let isSelected = color == selectedColor
            
            cell.configureColor(color, isSelected: isSelected)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        TrackerSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OptionHeaderViewController.identifier, for: indexPath) as? OptionHeaderViewController else {
            return UICollectionReusableView()
        }
        
        if let section = TrackerSection(rawValue: indexPath.section) {
            header.configure(title: section.title)
            
        }
        
        return header
    }
}

// MARK: Ext UICollectionViewDelegate
extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = TrackerSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .emojis:
            let previousIndex = TrackerEmojis.emojis.firstIndex(where: { $0 == selectedEmoji })
            selectedEmoji = TrackerEmojis.emojis[indexPath.row]
            
            var reloadIndexes: [IndexPath] = [indexPath]
            if let prev = previousIndex {
                reloadIndexes.append(IndexPath(row: prev, section: indexPath.section))
            }
            collectionView.reloadItems(at: reloadIndexes)
            
        case .colors:
            let previousIndex = TrackerColors.allCases.firstIndex(where: { $0.uiColor == selectedColor })
            selectedColor = TrackerColors.allCases[indexPath.row].uiColor
            
            var reloadIndexes: [IndexPath] = [indexPath]
            if let prev = previousIndex {
                reloadIndexes.append(IndexPath(row: prev, section: indexPath.section))
            }
            collectionView.reloadItems(at: reloadIndexes)
        }
        
        updateCreateButtonState()
    }
}

// MARK: Ext UICollectionViewDelegateFlowLayout
extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
}

extension NewTrackerViewController {
    
    var currentName: String? {
        nameTrackerTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == false
        ? nameTrackerTextField.text
        : nil
    }
    
    var currentEmoji: String? {
        selectedEmoji
    }
    
    var currentColor: UIColor? {
        selectedColor
    }
    
    var currentSchedule: Set<Weekday>? {
        selectedWeekdays.isEmpty ? nil : selectedWeekdays
    }
    
    var currentCategory: String? {
        selectedCategoryName
    }
    
    func setCreateButtonTitle(_ title: String) {
        createButton.setTitle(title, for: .normal)
    }
    
    func insertIntoContentStack(_ view: UIView, at index: Int, spacing: CGFloat? = nil) {
        contentStackView.insertArrangedSubview(view, at: index)
        if let spacing = spacing, index < contentStackView.arrangedSubviews.count - 1 {
            contentStackView.setCustomSpacing(spacing, after: view)
        }
    }
    
    func configureForEditing(tracker: Tracker, category: String) {
        nameTrackerTextField.text = tracker.name
        selectedEmoji = tracker.emoji
        selectedColor = tracker.color
        selectedWeekdays = tracker.schedule
        selectedCategoryName = category
        
        updateCategoryButtonTitle()
        updateScheduleButtonTitle()
        updateCreateButtonState()
        nameTrackerTextField.rightViewMode = .always
    }
    
    func setCreateButtonAction(_ action: @escaping () -> Void) {
        createButton.removeTarget(nil, action: nil, for: .allEvents)
        createButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
    }
}
