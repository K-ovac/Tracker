//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 12.02.2026.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didCreateCategory(_ category: Category)
}

final class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
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

        return textField
    }()
    
    private lazy var completeCategoryButton = setupBottomButton(title: "Готово")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        setupActions()
        updateCompleteButtonState()
    }
    
    private func setupView() {
        navigationItem.title = "Новая категория"
        view.backgroundColor = Colors.background
    
        view.addSubview(nameCategoryTextField)
        view.addSubview(completeCategoryButton)
    }
    
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
            completeCategoryButton.heightAnchor.constraint(equalToConstant: 60)
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
        updateCompleteButtonState()
        print("В поле ввода введен символ")
    }
    
    @objc private func didTapComplete() {
        print("Нажатие кнопки готово")
        guard let name = nameCategoryTextField.text, !name.isEmpty else { return }
        let newCategory = Category(name: name, isSelected: false)
        delegate?.didCreateCategory(newCategory)
        dismiss(animated: true)
    }
}
