//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 22.02.2026.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    //MARK: Properties
    private var isPageControlAdded = false
    
    //MARK: UI
    private lazy var pages: [UIViewController] = {
        OnboardingModel.models.map { model in
            OnboardingViewController(model: model)
        }
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlackOp30
        
        return pageControl
    }()
    
    //MARK: Inits
    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        setupView()
        setupLayout()
    }
    
    //MARK: SetupView
    private func setupView() {
        view.addSubview(pageControl)
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    //MARK: SetupLayout
    private func setupLayout() {
        [pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

//MARK: Ext UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
    
    
}

//MARK: Ext UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = currentIndex
        }
    }
}
