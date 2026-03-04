//
//  TabBarController.swift
//  Tracker
//
//  Created by Максим Лозебной on 27.01.2026.
//

import UIKit

private enum Assets {
    static let tracker = "trackerTabBarItem"
    static let statistics = "statisticsTabBarItem"
}

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabBar()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = Colors.backgroundView
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.backgroundView
        appearance.shadowColor = UIColor.separator
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = Colors.selectedItemTint
        tabBar.unselectedItemTintColor = Colors.inactiveIndicatorTint
    }
    
    //MARK: - Setup TabBar
    private func setupTabBar() {
        let trackerIcon = UIImage(named: Assets.tracker)?
            .withRenderingMode(.alwaysTemplate)
        let statisticsIcon = UIImage(named: Assets.statistics)?
            .withRenderingMode(.alwaysTemplate)
        
        let trackerVC = TrackerViewController()
        let trackerNav = UINavigationController(rootViewController: trackerVC)
        let statisticsVC = StatisticsViewController()
        let statisticsNav = UINavigationController(rootViewController: statisticsVC)
        
        let trackerTabBarItem = UITabBarItem(
            title: L10n.trackersScreenName,
            image: trackerIcon,
            selectedImage: nil
        )
        trackerTabBarItem.tag = 0
        trackerVC.tabBarItem = trackerTabBarItem
        
        let statisticsTabBarItem = UITabBarItem(
            title: L10n.statsScreenName,
            image: statisticsIcon,
            selectedImage: nil
        )
        statisticsTabBarItem.tag = 1
        statisticsVC.tabBarItem = statisticsTabBarItem
        
        viewControllers = [
            trackerNav,
            statisticsNav
        ]
    }
}
