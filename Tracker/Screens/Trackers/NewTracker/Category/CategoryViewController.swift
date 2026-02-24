//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 11.02.2026.
//

import UIKit

//MARK: CategoryViewControllerDelegate
protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ categoryName: String)
}

final class CategoryViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: CategoryViewControllerDelegate?
    
    private let categoryViewModel = CategoryViewModel()
    
    //MARK: - UI
    private lazy var addCategoryButton = setupBottomButton(
        title: "Добавить категорию"
    )
    private lazy var placeholderLabel = setupPlaceholderLabel(
        titleText: "Привычки и события можно \n объединять по смыслу"
    )
    private let categoryTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = 75
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        setupTableView()
        setupActions()
        
        bindingCategoryViewModel()
        hidePlaceholderLabel()
    }
    
    //MARK: - SetupView
    private func setupView() {
        navigationItem.title = "Категория"
        
        view.backgroundColor = Colors.background
        
        [
            categoryTableView,
            addCategoryButton,
            placeholderLabel,
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.reloadData()
        categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        categoryTableView.backgroundColor = .clear
        categoryTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    //MARK: - SetupLayout
    private func setupLayout() {
        [addCategoryButton, placeholderLabel, categoryTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.l),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metrics.t),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: Metrics.heightButton),
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -232),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
    
    private func setupPlaceholderLabel(titleText: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = false
        
        let title = UILabel()
        title.text = titleText
        title.textAlignment = .center
        title.textColor = Colors.textPrimary
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        title.numberOfLines = 2
        title.translatesAutoresizingMaskIntoConstraints = false
        
        
        let image = UIImageView(image: UIImage(named: "backgroundTrackerScreen"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        [image, title].forEach {
            stack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8)
        ])
        
        return stack
    }
    
    private func hidePlaceholderLabel() {
        placeholderLabel.isHidden = categoryViewModel.numberOfRows() != 0
    }
    
    //MARK: Binding
    private func bindingCategoryViewModel() {
        categoryViewModel.onCategoriesChange = { [weak self] in
            self?.categoryTableView.reloadData()
            self?.hidePlaceholderLabel()
        }
        
        categoryViewModel.onSelectCategoryChange = { [weak self] in
            self?.categoryTableView.reloadData()
        }
    }
    
    //MARK: Setup Actions
    private func setupActions() {
        addCategoryButton.addTarget(self,
                                    action: #selector(didTapAddCategory),
                                    for: .touchUpInside)
    }
    
    //MARK: Actions
    @objc private func didTapAddCategory() {
        print("Нажата кнопка добавления категории")
        let vc = NewCategoryViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

//MARK: Ext UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let isSelected = categoryViewModel.isSelected(index: indexPath.row)
        let category = categoryViewModel.category(at: indexPath.row)
        
        cell.configure(title: category.name, isSelected: isSelected)
        
        return cell
    }
}

//MARK: Ext UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryViewModel.selectCategory(at: indexPath.row)
        
        let category = categoryViewModel.category(at: indexPath.row)
        
        delegate?.didSelectCategory(category.name)
        
    }
}

//MARK: Ext NewCategoryViewControllerDelegate
extension CategoryViewController: NewCategoryViewControllerDelegate {
    func didCreateCategory(_ category: Category) {
        categoryViewModel.addCategory(title: category.name)
    }
}
