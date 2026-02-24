//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 12.02.2026.
//

import UIKit
//MARK: NewCategoryViewControllerDelegate
protocol NewCategoryViewControllerDelegate: AnyObject {
    func didCreateCategory(_ category: Category)
}

final class NewCategoryViewController: UIViewController {
    //MARK: Properties
    weak var delegate: NewCategoryViewControllerDelegate?
    
    //MARK: UI
    private lazy var nameCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
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
        textField.rightViewMode = .never
        
        return textField
    }()
    
    private lazy var completeCategoryButton = setupBottomButton(title: "Готово")
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        setupActions()
        updateCompleteButtonState()
    }
    
    //MARK: setupView
    private func setupView() {
        navigationItem.title = "Новая категория"
        view.backgroundColor = Colors.background
    
        view.addSubview(nameCategoryTextField)
        view.addSubview(completeCategoryButton)
    }
    
    //MARK: setupLayout
    private func setupLayout() {
        [nameCategoryTextField, completeCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.l),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metrics.t),
            nameCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            
            completeCategoryButton.leadingAnchor.constraint(equalTo: nameCategoryTextField.leadingAnchor),
            completeCategoryButton.trailingAnchor.constraint(equalTo: nameCategoryTextField.trailingAnchor),
            completeCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completeCategoryButton.heightAnchor.constraint(equalToConstant: Metrics.heightButton)
        ])
    }
    
    //MARK: - Factory methods
    private func setupBottomButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Metrics.defCornerRadius
        
        return button
    }
    
    // MARK: - Logic
    private func updateCompleteButtonState() {
        let nameValid = !(nameCategoryTextField.text?.isEmpty ?? true)
        let enabled = nameValid
        
        completeCategoryButton.isEnabled = enabled
        completeCategoryButton.backgroundColor = enabled ? .ypBlack : Colors.unselectedItem
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        nameCategoryTextField.addTarget(self,
                                        action: #selector(didSetNameCategory),
                                        for: .editingChanged)
        completeCategoryButton.addTarget(self,
                                         action: #selector(didTapComplete),
                                         for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didSetNameCategory() {
        let hasText = !(nameCategoryTextField.text?.isEmpty ?? true)
        nameCategoryTextField.rightViewMode = hasText ? .always : .never
        updateCompleteButtonState()
        print("В поле ввода введен символ")
    }
    
    @objc private func didTapComplete() {
        print("Нажатие кнопки готово")
        guard let name = nameCategoryTextField.text, !name.isEmpty else { return }
        let newCategory = Category(name: name)
        delegate?.didCreateCategory(newCategory)
        dismiss(animated: true)
    }
    
    @objc private func didTapClearText() {
        nameCategoryTextField.text = ""
        nameCategoryTextField.rightViewMode = .never
        updateCompleteButtonState()
        print("Поле названия трекера очищено")
    }
}
