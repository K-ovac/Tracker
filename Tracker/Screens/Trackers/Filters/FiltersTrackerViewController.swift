//
//  FiltersTrackerViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 28.02.2026.
//

import UIKit
//MARK: Ghjnjrjk lkz gthtlfxb pyfxtybz
protocol FiltersTrackerViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filterName: FiltersTracker)
}

final class FiltersTrackerViewController: UIViewController {
    //MARK: Properties
    weak var delegate: FiltersTrackerViewControllerDelegate?
    
    private let filterViewModel: FiltersTrackerViewModel
    
    //MARK: UI
    private let filtersTrackerView = FiltersTrackerView()
    
    //MARK: Init
    init(currentFilter: FiltersTracker) {
        self.filterViewModel = FiltersTrackerViewModel(currentFilter: currentFilter)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func loadView() {
        view = filtersTrackerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        configureTableViewDataAndDelegate()
        bindingFilterViewModel()
    }
    
    //MARK: Factory Methods
    private func setupNavigationBar() {
        navigationItem.title = L10n.filtersScreenName
    }
    
    private func configureTableViewDataAndDelegate() {
        filtersTrackerView.filtersTableView.delegate = self
        filtersTrackerView.filtersTableView.dataSource = self
    }
    
    private func bindingFilterViewModel() {
        filterViewModel.onFilterChanged = { [weak self] in
            self?.filtersTrackerView.filtersTableView.reloadData()
        }
    }
}

//MARK: Extension FiltersTrackerViewController: UITableViewDataSource
extension FiltersTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterTrackerCell.reuseIndentifier,
            for: indexPath
        ) as? FilterTrackerCell else {
            return UITableViewCell()
        }
        
        let title = filterViewModel.titleForRow(at: indexPath.row)
        let isSelected = filterViewModel.isSelected(at: indexPath.row)
        
        cell.configureCell(title: title, isSelected: isSelected)
        
        return cell
    }
    
}

//MARK: FiltersTrackerViewController: UITableViewDelegate
extension FiltersTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterViewModel.select(at: indexPath.row)
        
        if let selectedFilter = filterViewModel.selectedFilter() {
            delegate?.didSelectFilter(selectedFilter)
        }
    }
}
