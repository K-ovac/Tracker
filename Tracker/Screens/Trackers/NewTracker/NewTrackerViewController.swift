//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 08.02.2026.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func didTappedCreateNewTracker(_ tracker: Tracker, categoryTitle: String)
}

final class NewTrackerViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    private var selectedWeekdays: Set<Weekday> = []
    private var selectedCategoryName: String = "Важное"
    
    // MARK: - Scroll
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI
    private let nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = Colors.bckgGrayDay
        textField.layer.cornerRadius = Metrics.defCornerRadius
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        
        let clearButton = UIButton(type: .system)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .ypGray
        clearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        clearButton.addTarget(nil, action: #selector(didTapClearText), for: .touchUpInside)
        
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 24))
        rightContainer.addSubview(clearButton)
        clearButton.center = CGPoint(x: rightContainer.frame.width / 2 - 6, y: rightContainer.frame.height / 2)
        
        textField.rightView = rightContainer
        textField.rightViewMode = .whileEditing

        return textField
    }()
    
    private let nameLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 33).isActive = true
        return label
    }()
    
    private let categoryButton = NewTrackerViewController.setupOptionButton(title: "Категория")
    private let scheduleButton = NewTrackerViewController.setupOptionButton(title: "Расписание")
    
    private let scheduleSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    private let categorySubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private let separatorContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let cancelButton = NewTrackerViewController.makeBottomButton(
        title: "Отменить",
        titleColor: .red,
        background: .clear,
        border: true
    )
    
    private let createButton = NewTrackerViewController.makeBottomButton(
        title: "Создать",
        titleColor: .white,
        background: Colors.unselectedItem,
        border: false
    )
    
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
        stack.backgroundColor = Colors.bckgGrayDay
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
        updateCreateButtonState()
    }
    
    // MARK: - Setup
    private func setupView() {
        navigationItem.title = "Новая привычка"
        view.backgroundColor = Colors.background

        scheduleButton.addSubview(scheduleSubtitleLabel)
        categoryButton.addSubview(categorySubtitleLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(fieldStack)
        contentStackView.addArrangedSubview(optionsStackView)
        contentStackView.setCustomSpacing(24, after: fieldStack)

        optionsStackView.addArrangedSubview(categoryButton)

        separatorContainer.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: separatorContainer.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: separatorContainer.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor),
            separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor),
            separatorContainer.heightAnchor.constraint(equalToConstant: 1)
        ])
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
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.l),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metrics.t),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            separator.leadingAnchor.constraint(equalTo: separatorContainer.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: separatorContainer.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor),
            separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separatorContainer.heightAnchor.constraint(equalToConstant: 1),
            
            scheduleSubtitleLabel.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
            scheduleSubtitleLabel.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            scheduleSubtitleLabel.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -14),
            
            categorySubtitleLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            categorySubtitleLabel.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            categorySubtitleLabel.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -14),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.l),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metrics.t),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Factory methods
    private static func setupOptionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tintColor = .ypBlack
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
        button.backgroundColor = background
        button.layer.cornerRadius = Metrics.defCornerRadius
        button.layer.masksToBounds = true
        if border {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.red.cgColor
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
        ? "Каждый день"
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
        let enabled = nameValid && !selectedWeekdays.isEmpty
        createButton.isEnabled = enabled
        createButton.backgroundColor = enabled ? .ypBlack : Colors.unselectedItem
    }
    
    // MARK: - Actions
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(didTapSchedule), for: .touchUpInside)
        nameTrackerTextField.addTarget(self, action: #selector(didSetNameTracker), for: .editingChanged)
    }
    
    @objc private func didTapCancel() {
        print("Нажата кнопка отмены")
        dismiss(animated: true)
    }
    
    @objc private func didTapCreate() {
        print("Нажата кнопка создать")
        guard let name = nameTrackerTextField.text else { return }
        let tracker = Tracker(id: UUID(),
                              name: name,
                              color: .ypBlue,
                              emoji: "💩",
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

        let showLimit = (nameTrackerTextField.text?.count ?? 0) > 38
        nameLimitLabel.isHidden = !showLimit
        print("В поле ввода введен символ")
    }
    
    @objc private func didTapClearText() {
        nameTrackerTextField.text = ""
        updateCreateButtonState()
        print("Поле названия трекера очищено")
    }
}

// MARK: - Delegates
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ weekdays: Set<Weekday>) {
        selectedWeekdays = weekdays
        print("Выбраны дни - \(selectedWeekdays.count): \(selectedWeekdays)")
        updateCategoryButtonTitle()
        updateScheduleButtonTitle()
        updateCreateButtonState()
    }
}

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
